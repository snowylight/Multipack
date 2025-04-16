--- STEAMODDED HEADER
--- MOD_NAME: Multipack
--- MOD_ID: Multipack
--- MOD_AUTHOR: [sishui]
--- MOD_DESCRIPTION: Multipack
--- BADGE_COLOUR: 9932CC
--- PREFIX: mupack
--- VERSION: 2.2.0
----------------------------------------------
------------MOD CODE -------------------------
SMODS.Atlas({key = 'mupack', path = 'multipacks1.png', px = 71, py = 95 })
SMODS.Atlas({key = 'freemupack', path = 'multipacks2.png', px = 71, py = 95 })
SMODS.Atlas({key = 'blankpack', path = 'blankpack.png', px = 71, py = 95 })
SMODS.Atlas({key = 'clonepack', path = 'clonepack.png', px = 71, py = 95 })
SMODS.Atlas({key = 'naturalpack', path = 'naturalpack.png', px = 71, py = 95 })
SMODS.Atlas({key = 'halfpack', path = 'halfpack.png', px = 71, py = 95 })
SMODS.Atlas({key = 'burntpack', path = 'burntpack.png', px = 71, py = 95 })
SMODS.Atlas({key = 'misprintpack', path = 'misprintpack.png', px = 71, py = 95 })
SMODS.Atlas({key = 'taboopack', path = 'taboopack.png', px = 71, py = 95 })
SMODS.Atlas({key = 'yinyangpack', path = 'yinyangpack.png', px = 71, py = 95 })
SMODS.Atlas({key = 'bonuspack', path = 'bonuspack.png', px = 71, py = 95 })

local alias__G_UIDEF_use_and_sell_buttons = G.UIDEF.use_and_sell_buttons;
function G.UIDEF.use_and_sell_buttons(card)
    local ret = alias__G_UIDEF_use_and_sell_buttons(card)
    
    if card.config.center.key and (card.area == G.pack_cards and G.pack_cards) and card.ability.set == "Booster" then
        return {
            n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.R, config={mid = true}, nodes={
                }},
                {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, minh = 0.8*card.T.h, maxw = 0.7*card.T.w - 0.15, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_mupack', func = 'can_use_mupack'}, nodes={
                {n=G.UIT.T, config={text = localize('b_select'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
            }},
        }}
    end

    return ret
end

G.FUNCS.can_use_mupack = function(e)
    if e.config.ref_table.ability.set == 'Booster' then 
        e.config.colour = G.C.GREEN
        e.config.button = 'use_mupack'
    else
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
    end
end

G.FUNCS.use_mupack = function(e, mute, nosave)
    local c1 = e.config.ref_table
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,
        func = function()
          card_eval_status_text(c1, 'extra', nil, nil, nil, {message = "" .. localize('k_addpack'), colour = G.C.MULT})
          c1:remove()
          if c1.children.price then c1.children.price:remove() end
          c1.children.price = nil
          if c1.children.buy_button then c1.children.buy_button:remove() end
          c1.children.buy_button = nil
          remove_nils(c1.children)
          G.GAME.pack_choices = G.GAME.pack_choices - 1
          if G.GAME.pack_choices <= 0 then
            G.FUNCS.end_consumeable(nil, delay_fac)
          end
        G.shop_booster.config.card_limit = G.shop_booster.config.card_limit + 1
        local card = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
        G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[c1.config.center.key], {bypass_discovery_center = true, bypass_discovery_ui = true})
        create_shop_card_ui(card, 'Booster', G.shop_booster)
        card.ability.booster_pos = G.shop_booster.config.card_limit
        if G.GAME.modifiers.multipack4 == true then
        card.cost=math.floor(card.cost*0.5)
        end
        if G.GAME.modifiers.multipack5 == true then
        card.cost=0
        end
        G.shop_booster:emplace(card)
        if G.GAME.pack_choices <= 0 then
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = false
        end
          return true
        end
    }))
end

local Card_set_ability_ref = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    Card_set_ability_ref(self, center, initial, delay_sprites)
    local X, Y, W, H = self.T.x, self.T.y, self.T.w, self.T.h
    if center.name == "Half Pack" and (center.discovered or self.bypass_discovery_center) then 
        H = H/1.7
        self.T.h = H
    end
end

local Card_set_sprites_ref = Card.set_sprites
function Card:set_sprites(_center, _front)
    Card_set_sprites_ref(self, _center, _front)
    if _center then 
        if _center.set then
            if _center.name == 'Half Pack' and (_center.discovered or self.bypass_discovery_center) then 
                self.children.center.scale.y = self.children.center.scale.y/1.7
            end
        end
    end
end

local Card_load_ref = Card.load
function Card:load(cardTable, other_card)
    Card_load_ref(self, cardTable, other_card)
    local scale = 1
    local H = G.CARD_H
    local W = G.CARD_W
    if self.config.center.name == "Half Pack" then
        self.T.h = H*1.27*scale/1.7*scale
        self.T.w = W*1.27*scale
    end
end

SMODS.Booster{
    key = "multipack1",
    group_key = "k_multipack",
    atlas = 'mupack',
    pos = {x = 0, y = 0},
    weight = 0.2,
    cost = 2,
    config = {extra = 3, choose = 1},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    create_card = function(self, card)
        return {set = "Booster", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "mupack"}
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.MULT, contrast = 1}
    end,
    create_UIBox = function(self)
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = false
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_multipack')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}

SMODS.Booster{
    key = "multipack2",
    group_key = "k_multipack",
    atlas = 'mupack',
    pos = {x = 1, y = 0},
    weight = 0.2,
    cost = 3,
    config = {extra = 4, choose = 2},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    create_card = function(self, card)
        return {set = "Booster", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "mupack"}
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.MULT, contrast = 1}
    end,
    create_UIBox = function(self)
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = false
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_multipack')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}

SMODS.Booster{
    key = "multipack3",
    group_key = "k_multipack",
    atlas = 'mupack',
    pos = {x = 2, y = 0},
    weight = 0.1,
    cost = 4,
    config = {extra = 5, choose = 3},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    create_card = function(self, card)
        return {set = "Booster", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "mupack"}
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.MULT, contrast = 1}
    end,
    create_UIBox = function(self)
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = false
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_multipack')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}

SMODS.Booster{
    key = "multipack4",
    group_key = "k_multipack",
    atlas = 'freemupack',
    pos = {x = 0, y = 0},
    weight = 0.1,
    cost = 6,
    config = {extra = 4, choose = 2},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    create_card = function(self, card)
        return {set = "Booster", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "mupack"}
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.MULT, contrast = 1}
    end,
    create_UIBox = function(self)
        G.GAME.modifiers.multipack4 = true
        G.GAME.modifiers.multipack5 = false
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_multipack')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}

SMODS.Booster{
    key = "multipack5",
    group_key = "k_multipack",
    atlas = 'freemupack',
    pos = {x = 1, y = 0},
    weight = 0.1,
    cost = 8,
    config = {extra = 5, choose = 2},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    create_card = function(self, card)
        return {set = "Booster", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "mupack"}
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.MULT, contrast = 1}
    end,
    create_UIBox = function(self)
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = true
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_multipack')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}

SMODS.Booster{
    key = "favoritepack",
    group_key = "k_favoritepack",
    atlas = 'freemupack',
    pos = {x = 2, y = 0},
    weight = 0.1,
    cost = 12,
    config = {extra = 5, choose = 1},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    create_card = function(self, card, i)
        local used_cards = {}
        local max_amt = 0
        for k, v in pairs(G.PROFILES[G.SETTINGS.profile]['joker_usage']) do
            if G.P_CENTERS[k] and G.P_CENTERS[k].discovered then
            used_cards[#used_cards + 1] = {count = v.count, key = k}
            if v.count > max_amt then max_amt = v.count end
            end
        end

        table.sort(used_cards, function (a, b) return a.count > b.count end )
        
        local _card
        local v = used_cards[i]
            if v then 
                _card = {set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = false, key = v.key, key_append = "fav1"}
            else
                _card = {set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "fav2"}
            end
        return _card
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.MULT, contrast = 1}
    end,
    create_UIBox = function(self)
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_favoritepack')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}

SMODS.Booster{
    key = "blankpack",
    group_key = "k_blankpack",
    atlas = 'blankpack',
    pos = {x = 0, y = 0},
    weight = 0.15,
    cost = 8,
    draw_hand = true,
    config = {extra = 7, choose = 1},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    create_card = function(self, card, i)
        if i%7 == 1 then
            if pseudorandom('soul'..G.GAME.round_resets.ante) > 0.8 then
                return create_card('Spectral', G.pack_cards, nil, nil, true, nil, 'c_soul', 'blankpack1')
            else
                return create_card('Voucher', G.pack_cards, nil, nil, true, nil, 'v_blank', 'blankpack2')
            end
        elseif i%7 == 2 then
        return {set = "Booster", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "blankpack3"}
        elseif i%7 == 3 then
        return {set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "blankpack4"}
        elseif i%7 == 4 then
        return {set = "Tarot", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "blankpack5"}
        elseif i%7 == 5 then
        return {set = "Planet", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "blankpack6"}
        elseif i%7 == 6 then
        return {set = "Spectral", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "blankpack7"}
        elseif i%7 == 0 then
            local _edition = poll_edition('standard_edition'..G.GAME.round_resets.ante, 2, true)
            local _seal = SMODS.poll_seal({mod = 10})
        return {set = (pseudorandom(pseudoseed('stdset'..G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base", edition = _edition, seal = _seal, area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "blankpack8"}
        end
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.GREEN, contrast = 10}
    end,
    create_UIBox = function(self)
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = false
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_blankpack')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}

SMODS.Booster{
    key = "clonepack",
    group_key = "k_clonepack",
    atlas = 'clonepack',
    pos = {x = 0, y = 0},
    weight = 0.05,
    cost = 10,
    draw_hand = true,
    config = {extra = 3, choose = 2},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    create_card = function(self, card, i)
        if i == 1 then
        if G.shop_jokers and G.shop_jokers.cards[i] and (G.shop_jokers.cards[i].ability.set == 'Joker' or G.shop_jokers.cards[i].ability.consumeable) then
        --return create_card('Joker', G.pack_cards, nil, nil, true, nil, G.shop_jokers.cards[i].config.center.key, 'clonepack')
        return copy_card(G.shop_jokers.cards[i], nil, nil, nil, nil)
        elseif G.shop_jokers and G.shop_jokers.cards[i] and (G.shop_jokers.cards[i].ability.name == 'Default Base' or G.shop_jokers.cards[i].ability.set == 'Enhanced') then
        return copy_card(G.shop_jokers.cards[i], nil, nil, G.playing_card)
        else
        return {set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "clonepack1"}
        end
        elseif i == card.ability.extra then
        if G.shop_jokers and G.shop_jokers.cards[#G.shop_jokers.cards] and (G.shop_jokers.cards[#G.shop_jokers.cards].ability.set == 'Joker' or G.shop_jokers.cards[#G.shop_jokers.cards].ability.consumeable) then
        --return create_card('Joker', G.pack_cards, nil, nil, true, nil, G.shop_jokers.cards[i].config.center.key, 'clonepack')
        return copy_card(G.shop_jokers.cards[#G.shop_jokers.cards], nil, nil, nil, nil)
        elseif G.shop_jokers and G.shop_jokers.cards[#G.shop_jokers.cards] and (G.shop_jokers.cards[#G.shop_jokers.cards].ability.name == 'Default Base' or G.shop_jokers.cards[#G.shop_jokers.cards].ability.set == 'Enhanced') then
        return copy_card(G.shop_jokers.cards[#G.shop_jokers.cards], nil, nil, G.playing_card)
        else
        return {set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "clonepack2"}
        end
        else
        return {set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "clonepack3"}
        end
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.GREEN, contrast = 10}
    end,
    create_UIBox = function(self)
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = false
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_clonepack')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}

local game_updateref = Game.update
function Game:update(dt)
    local ret = game_updateref(self, dt)

    if not (SMODS.Mods["NotJustYet"] or {}).can_load then
    if G.GAME and G.GAME.blind and
      (((SMODS.Mods["Talisman"] or {}).can_load and ((to_number(G.GAME.chips) - to_number(G.GAME.blind.chips)) >= 0)) or
      (not (SMODS.Mods["Talisman"] or {}).can_load and (G.GAME.chips - G.GAME.blind.chips) >= 0)) then
        if G.STATE == G.STATES.SELECTING_HAND then
          G.STATE = G.STATES.HAND_PLAYED
          G.STATE_COMPLETE = true
          end_round()
        end
    end
    end

    return ret
end

local discard_end_consumeable = G.FUNCS.end_consumeable;
function G.FUNCS.end_consumeable(e, delayfac)
    local ret = discard_end_consumeable(e, delayfac)
    
    G.FUNCS.draw_from_discard_to_deck()

    return ret
end

G.FUNCS.can_reroll_pack1 = function(e)
    if ((G.GAME.dollars-G.GAME.bankrupt_at) - G.GAME.current_round.reroll_cost < 0) and G.GAME.current_round.reroll_cost ~= 0 then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
        --e.children[1].children[1].config.shadow = false
        --e.children[2].children[1].config.shadow = false
        --e.children[2].children[2].config.shadow = false
    else
        e.config.colour = G.C.GREEN
        e.config.button = 'reroll_shop_pack1'
        --e.children[1].children[1].config.shadow = true
        --e.children[2].children[1].config.shadow = true
        --e.children[2].children[2].config.shadow = true
    end
end

G.FUNCS.reroll_shop_pack1 = function(e) 
    stop_use()
    G.CONTROLLER.locks.shop_reroll = true
    if G.CONTROLLER:save_cardarea_focus('pack_cards') then G.CONTROLLER.interrupt.focus = true end
    if G.GAME.current_round.reroll_cost > 0 then 
      inc_career_stat('c_shop_dollars_spent', G.GAME.current_round.reroll_cost)
      inc_career_stat('c_shop_rerolls', 1)
      ease_dollars(-G.GAME.current_round.reroll_cost)
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
          local final_free = G.GAME.current_round.free_rerolls > 0
          G.GAME.current_round.free_rerolls = math.max(G.GAME.current_round.free_rerolls - 1, 0)
          G.GAME.round_scores.times_rerolled.amt = G.GAME.round_scores.times_rerolled.amt + 1

          calculate_reroll_cost(final_free)
          for i = #G.pack_cards.cards,1, -1 do
            local c = G.pack_cards:remove_card(G.pack_cards.cards[i])
            c:remove()
            c = nil
          end

          --save_run()

          play_sound('coin2')
          play_sound('other1')
          --local pack_cards = {}
          G.GAME.pack_size = SMODS.OPENED_BOOSTER.ability.extra or 1
          for i = 1, G.GAME.pack_size do
            if pseudorandom(pseudoseed('naturalpack')) < 0.5 then
            local new_booster_card = create_card('Tarot', G.pack_cards, nil, nil, true, nil, nil, "naturalpackreroll1")
            --create_card('Tarot', G.pack_cards, nil, nil, true, nil, nil, "naturalpackreroll1")
            else
            local new_booster_card = create_card('Spectral', G.pack_cards, nil, nil, true, nil, nil, "naturalpackreroll2")
            --create_card('Spectral', G.pack_cards, nil, nil, true, nil, nil, "naturalpackreroll2")
            end
            --pack_cards[i] = new_booster_card
            G.pack_cards:emplace(new_booster_card)
            new_booster_card:juice_up()
          end

          --[[G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1.3*math.sqrt(G.SETTINGS.GAMESPEED), blockable = false, blocking = false, func = function()
            if G.pack_cards then 
                if G.pack_cards and G.pack_cards.VT.y < G.ROOM.T.h then 
                for k, v in ipairs(pack_cards) do
                    G.pack_cards:emplace(v)
                    v:juice_up()
                end
                return true
                end
            end
        end}))]]

          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = function()
        G.E_MANAGER:add_event(Event({
          func = function()
            G.CONTROLLER.interrupt.focus = false
            G.CONTROLLER.locks.shop_reroll = false
            G.CONTROLLER:recall_cardarea_focus('pack_cards')
            for i = 1, #G.jokers.cards do
              G.jokers.cards[i]:calculate_joker({reroll_shop = true})
            end
            return true
          end
        }))
        return true
      end
    }))
    G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
end

G.FUNCS.can_play_pack = function(e)
    if #G.hand.highlighted <= 0 or G.GAME.blind.block_play or #G.hand.highlighted > 5 or G.GAME.current_round.hands_left <= 0 then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.BLUE
        e.config.button = 'play_cards_from_highlighted_pack'
    end
end

G.FUNCS.play_cards_from_highlighted_pack = function(e)
    if G.play and G.play.cards[1] then return end
    --check the hand first

    stop_use()
    G.GAME.blind.triggered = false
    G.CONTROLLER.interrupt.focus = true
    G.CONTROLLER:save_cardarea_focus('pack_cards')

    for k, v in ipairs(G.playing_cards) do
        v.ability.forced_selection = nil
    end
    
    table.sort(G.hand.highlighted, function(a,b) return a.T.x < b.T.x end)

    --[[G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.STATE = G.STATES.HAND_PLAYED
            G.STATE_COMPLETE = true
            return true
        end
    }))]]
    inc_career_stat('c_cards_played', #G.hand.highlighted)
    inc_career_stat('c_hands_played', 1)
    ease_hands_played(-1)
    --G.FUNCS.draw_from_hand_to_deck()
    --G.FUNCS.draw_from_discard_to_deck()
    delay(0.4)

        for i=1, #G.hand.highlighted do
            if G.hand.highlighted[i]:is_face() then inc_career_stat('c_face_cards_played', 1) end
            G.hand.highlighted[i].base.times_played = G.hand.highlighted[i].base.times_played + 1
            G.hand.highlighted[i].ability.played_this_ante = true
            G.GAME.round_scores.cards_played.amt = G.GAME.round_scores.cards_played.amt + 1
            draw_card(G.hand, G.play, i*100/#G.hand.highlighted, 'up', nil, G.hand.highlighted[i])
        end

        check_for_unlock({type = 'run_card_replays'})

        if G.GAME.blind:press_play() then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = (function()
                    SMODS.juice_up_blind()
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    return true
                end)
            }))
            delay(0.4)
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                check_for_unlock({type = 'hand_contents', cards = G.play.cards})

                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.FUNCS.evaluate_play()
                        return true
                    end
                }))

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        check_for_unlock({type = 'play_all_hearts'})
                        G.FUNCS.draw_from_play_to_discard()
                        G.GAME.hands_played = G.GAME.hands_played + 1
                        G.GAME.current_round.hands_played = G.GAME.current_round.hands_played + 1
                        return true
                    end
                }))
                --G.FUNCS.draw_from_deck_to_hand(G.hand.config.card_limit-#G.hand.cards)
                --G.FUNCS.draw_from_discard_to_deck()
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.FUNCS.draw_from_deck_to_hand(nil)
                        return true
                    end
                }))
                return true
            end)
        }))
end

G.FUNCS.can_discard_pack = function(e)
    if G.GAME.current_round.discards_left <= 0 or #G.hand.highlighted <= 0 then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.RED
        e.config.button = 'discard_cards_from_highlighted_pack'
    end
end

G.FUNCS.discard_cards_from_highlighted_pack = function(e, hook)
    stop_use()
    G.CONTROLLER.interrupt.focus = true
    G.CONTROLLER:save_cardarea_focus('pack_cards')

    for k, v in ipairs(G.playing_cards) do
        v.ability.forced_selection = nil
    end

    if G.CONTROLLER.focused.target and G.CONTROLLER.focused.target.area == G.hand then G.card_area_focus_reset = {area = G.hand, rank = G.CONTROLLER.focused.target.rank} end
    local highlighted_count = math.min(#G.hand.highlighted, G.discard.config.card_limit - #G.play.cards)
    if highlighted_count > 0 then 
        update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
        table.sort(G.hand.highlighted, function(a,b) return a.T.x < b.T.x end)
        inc_career_stat('c_cards_discarded', highlighted_count)
        for i = 1, #G.hand.cards do
            eval_card(G.hand.cards[i], {pre_discard = true, full_hand = G.hand.highlighted, hook = hook})
        end
        for j = 1, #G.jokers.cards do
            G.jokers.cards[j]:calculate_joker({pre_discard = true, full_hand = G.hand.highlighted, hook = hook})
        end
        local cards = {}
        local destroyed_cards = {}
        for i=1, highlighted_count do
            local removed = false
            local eval = nil
            eval = eval_card(G.hand.highlighted[i], {discard = true, full_hand = G.hand.highlighted})
            if eval and eval.remove then
                removed = true
                card_eval_status_text(G.hand.highlighted[i], 'jokers', nil, 1, nil, eval)
            end
            for j = 1, #G.jokers.cards do
                local eval = nil
                eval = G.jokers.cards[j]:calculate_joker({discard = true, other_card =  G.hand.highlighted[i], full_hand = G.hand.highlighted, callback = function(card, eval)
                if eval then
                    if eval.remove then removed = true end
                    card_eval_status_text(card, 'jokers', nil, 1, nil, eval)
                end
            end})

            end
            table.insert(cards, G.hand.highlighted[i])
            if removed then
                destroyed_cards[#destroyed_cards + 1] = G.hand.highlighted[i]
                if G.hand.highlighted[i].ability.name == 'Glass Card' then 
                    G.hand.highlighted[i]:shatter()
                else
                    G.hand.highlighted[i]:start_dissolve()
                end
            else 
                G.hand.highlighted[i].ability.discarded = true
                draw_card(G.hand, G.discard, i*100/highlighted_count, 'down', false, G.hand.highlighted[i])
            end
        end

        if destroyed_cards[1] then 
            for j=1, #G.jokers.cards do
                eval_card(G.jokers.cards[j], {cardarea = G.jokers, remove_playing_cards = true, removed = destroyed_cards})
            end
        end

        G.GAME.round_scores.cards_discarded.amt = G.GAME.round_scores.cards_discarded.amt + #cards
        check_for_unlock({type = 'discard_custom', cards = cards})
        if not hook then
            if G.GAME.modifiers.discard_cost then
                ease_dollars(-G.GAME.modifiers.discard_cost)
            end
            ease_discard(-1)
            G.GAME.current_round.discards_used = G.GAME.current_round.discards_used + 1
            G.FUNCS.draw_from_deck_to_hand(#G.hand.highlighted)
            --G.FUNCS.draw_from_discard_to_deck()
            --[[G.STATE = G.STATES.DRAW_TO_HAND
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE_COMPLETE = false
                    return true
                end
            }))]]
        end
    end
end

SMODS.Booster{
    key = "naturalpack",
    group_key = "k_naturalpack",
    atlas = 'naturalpack',
    pos = {x = 0, y = 0},
    weight = 0.05,
    cost = 10,
    draw_hand = true,
    config = {extra = 5, choose = 2},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "pack_tip1", set = "Other"}
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    create_card = function(self, card, i)
        if pseudorandom(pseudoseed('naturalpack')) < 0.5 then
        return {set = "Tarot", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "naturalpack1"}
        else
        return {set = "Spectral", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "naturalpack2"}
        end
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.GREEN, contrast = 10}
    end,
    create_UIBox = function(self)
        --ease_discard(1)
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = false
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.CHIPS, button = "play_cards_from_highlighted_pack", hover = true,shadow = true, func = 'can_play_pack'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_play_hand'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}},
                --}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_naturalpack')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                                --[[{n=G.UIT.R, config={align = "cm", minw = 0.9, minh = 0.5, r=0.15,colour = G.C.GREEN, button = 'reroll_shop_pack1', func = 'can_reroll_pack1', hover = true,shadow = true}, nodes = {
                                    {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                                      {n=G.UIT.R, config={align = "cm", maxw = 0.5}, nodes={
                                        {n=G.UIT.T, config={text = localize('k_reroll'), scale = 0.5, colour = G.C.WHITE, shadow = true}},
                                      }},
                                      {n=G.UIT.R, config={align = "cm", maxw = 0.5, minw = 0.6}, nodes={
                                        {n=G.UIT.T, config={text = localize('$'), scale = 0.5, colour = G.C.WHITE, shadow = true}},
                                        {n=G.UIT.T, config={ref_table = G.GAME.current_round, ref_value = 'reroll_cost', scale = 0.5, colour = G.C.WHITE, shadow = true}},
                                      }}
                                    }}
                                  }},]]
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.MULT, button = "discard_cards_from_highlighted_pack", hover = true,shadow = true, func = 'can_discard_pack'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_discard'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}},
                        {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                            {n=G.UIT.R,config={minh =0.2}, nodes={}},
                            {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                                {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}},
                    }}}}}}
        return t
    end,
}

SMODS.Booster{
    key = "halfpack",
    name = "Half Pack",
    group_key = "k_halfpack",
    atlas = 'halfpack',
    pos = {x = 0, y = 0},
    weight = 0.01,
    cost = 0,
    config = {extra = 5, choose = 2},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        --info_queue[#info_queue+1] = G.P_CENTERS.j_half
        info_queue[#info_queue+1] = {key = 'perishable', set = 'Other', specific_vars = {G.GAME.perishable_rounds, 0}}
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    load = function(self, cardTable, other_card)
    end,
    create_card = function(self, card, i)
        if pseudorandom(pseudoseed('halfpack')) < 0.33 then
            local card = create_card('Joker', G.pack_cards, nil, nil, true, nil, nil, "halfpack1")
            card:set_debuff(true)
            card:set_perishable(true)
            card.ability.perish_tally = 0
        return card
        elseif pseudorandom(pseudoseed('halfpack')) > 0.66 then
        return create_card('Joker', G.pack_cards, nil, nil, true, nil, "j_half", "halfpack2")
        else
        return create_card('Joker', G.pack_cards, nil, nil, true, nil, nil, "halfpack3")
        end
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.GREEN, contrast = 10}
    end,
    create_UIBox = function(self)
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = false
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_halfpack')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}

SMODS.Sticker {
	key = "pack_burnt",
	loc_txt = {},
	rate = 0,
    atlas = 'bonuspack',
	pos = { x = 2, y = 0 },
    order = 1,
	badge_colour = HEX 'f08080',
	default_compat = true,
	compat_exceptions = {},
	sets = { Joker = true },
	needs_enable_flag = false,
    calculate = function(self, card, context)
        if context.pre_discard and G.GAME.current_round.discards_used <= 0 and not context.hook then
            local text,disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(text, 'poker_hands'),chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level=G.GAME.hands[text].level})
            level_up_hand(context.blueprint_card or card, text, nil, 1)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        end
    end
}

SMODS.Booster{
    key = "burntpack",
    group_key = "k_burntpack",
    atlas = 'burntpack',
    pos = {x = 0, y = 0},
    weight = 0.01,
    cost = 10,
    config = {extra = 5, choose = 2},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'mupack_pack_burnt', set = 'Other'}
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    load = function(self, cardTable, other_card)
    end,
    create_card = function(self, card, i)
        if pseudorandom(pseudoseed('burntpack')) < 0.25 then
            local card = create_card('Joker', G.pack_cards, nil, nil, true, nil, nil, "burntpack1")
            if card.ability.name ~= 'Burnt Joker' then
                SMODS.Stickers["mupack_pack_burnt"]:apply(card, true)
            end
        return card
        else
        return create_card('Joker', G.pack_cards, nil, nil, true, nil, nil, "burntpack2")
        end
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.GREEN, contrast = 10}
    end,
    create_UIBox = function(self)
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = false
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_burntpack')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}

SMODS.Sticker {
	key = "pack_misprintstencil",
	loc_txt = {},
	rate = 0,
    atlas = 'bonuspack',
	pos = { x = 2, y = 0 },
    order = 1,
	badge_colour = HEX 'ff6347',
	default_compat = true,
	compat_exceptions = {},
	sets = { Joker = true },
	needs_enable_flag = false,
    calculate = function(self, card, context)
        if context.joker_main and context.cardarea == G.jokers then
            local temp_Mult = pseudorandom('misprint', 0, 23)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={temp_Mult}}})
                            return {
                                --message = localize{type='variable',key='a_mult',vars={temp_Mult}},
                                mult_mod = temp_Mult,
                                message = localize{type='variable',key='a_xmult',vars={card.ability.x_mult}},
                                Xmult_mod = card.ability.x_mult
                            }
        end
    end
}

SMODS.Booster{
    key = "stencilpack",
    group_key = "k_stencilpack",
    atlas = 'misprintpack',
    pos = {x = 0, y = 0},
    weight = 0.08,
    cost = 12,
    config = {extra = 5, choose = 2},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        --info_queue[#info_queue+1] = G.P_CENTERS.j_stencil
        info_queue[#info_queue+1] = {key = 'mupack_pack_misprintstencil', set = 'Other'}
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    load = function(self, cardTable, other_card)
    end,
    create_card = function(self, card, i)
        if pseudorandom(pseudoseed('stencilpack')) < 0.2 then
            local card = create_card('Joker', G.pack_cards, nil, nil, true, nil, "j_stencil", "stencilpack1")
                SMODS.Stickers["mupack_pack_misprintstencil"]:apply(card, true)
        return card
        else
        return create_card('Joker', G.pack_cards, nil, nil, true, nil, "j_stencil", "stencilpack2")
        end
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.GREEN, contrast = 10}
    end,
    create_UIBox = function(self)
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = false
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_stencilpack')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}

SMODS.Booster{
    key = "taboopack",
    group_key = "k_taboopack",
    atlas = 'taboopack',
    pos = {x = 0, y = 0},
    weight = 0.1,
    cost = 10,
    config = {extra = 5, choose = 2},
    discovered = true,
    draw_hand = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    load = function(self, cardTable, other_card)
    end,
    create_card = function(self, card, i)
        local card = create_card('Tarot', G.pack_cards, nil, nil, true, nil, nil, "taboopack")
        if card.ability.name == 'Temperance' or card.ability.name == 'The Hermit' then
            card.ability.extra = 1e100
        end
        return card
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.GREEN, contrast = 10}
    end,
    create_UIBox = function(self)
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = false
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_taboopack')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}

SMODS.Booster{
    key = "yinyangpack",
    group_key = "k_yinyangpack",
    atlas = 'yinyangpack',
    pos = {x = 0, y = 0},
    weight = 0.02,
    cost = 12,
    config = {extra = 5, choose = 1},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        --info_queue[#info_queue+1] = {key = 'mupack_pack_yinyang', set = 'Other'}
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    load = function(self, cardTable, other_card)
    end,
    create_card = function(self, card, i)
        local _card
            if i == 1 then
                local _planet, _hand, _tally = nil, nil, 0
                for k, v in ipairs(G.handlist) do
                    if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                        _hand = v
                        _tally = G.GAME.hands[v].played
                    end
                end
                if _hand then
                    for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                        if v.config.hand_type == _hand then
                            _planet = v.key
                        end
                    end
                end
                _card1 = create_card("Planet", G.pack_cards, nil, nil, true, nil, _planet, 'yinyangpack1')
            else
                _card1 = create_card("Planet", G.pack_cards, nil, nil, true, nil, nil, 'yinyangpack1')
                _card2 = create_card("Planet", G.consumeables, nil, nil, true, nil, _card1.config.center.key, 'yinyangpack1')
                _card2:set_edition({negative = true}, true)
                _card2:add_to_deck()
                G.consumeables:emplace(_card2)
            end
            return _card1
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.GREEN, contrast = 10}
    end,
    create_UIBox = function(self)
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = false
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_yinyangpack')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}

SMODS.Booster{
    key = "extrabonuspack1",
    group_key = "k_extrabonuspack1",
    atlas = 'bonuspack',
    pos = {x = 0, y = 0},
    weight = 0.15,
    cost = 10,
    config = {extra = 5, choose = 2},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    load = function(self, cardTable, other_card)
    end,
    create_card = function(self, card, i)
        card = create_card((pseudorandom(pseudoseed('stdset'..G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base", G.pack_cards, nil, nil, nil, true, nil, 'extrabonuspack1')
        local edition_rate = 4
        local edition = poll_edition('standard_edition'..G.GAME.round_resets.ante, edition_rate, true)
        card:set_edition(edition)
        card:set_seal(SMODS.poll_seal({mod = 20}))
        card.ability.perma_bonus = pseudorandom('bonuspack1', 1, 30)
        return card
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.GREEN, contrast = 10}
    end,
    create_UIBox = function(self)
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = false
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_extrabonuspack1')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}

SMODS.Booster{
    key = "extrabonuspack2",
    group_key = "k_extrabonuspack2",
    atlas = 'bonuspack',
    pos = {x = 1, y = 0},
    weight = 0.1,
    cost = 12,
    config = {extra = 5, choose = 2},
    discovered = true,
    loc_txt ={},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra} }
    end,
    load = function(self, cardTable, other_card)
    end,
    create_card = function(self, card, i)
        card = create_card((pseudorandom(pseudoseed('stdset'..G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base", G.pack_cards, nil, nil, nil, true, nil, 'extrabonuspack2')
        local edition_rate = 8
        local edition = poll_edition('standard_edition'..G.GAME.round_resets.ante, edition_rate, true)
        card:set_edition(edition)
        card:set_seal(SMODS.poll_seal({mod = 40}))
        card.ability.perma_bonus = pseudorandom('bonuspack1', 31, 100)
        return card
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.CHIPS, special_colour = G.C.GREEN, contrast = 10}
    end,
    create_UIBox = function(self)
        G.GAME.modifiers.multipack4 = false
        G.GAME.modifiers.multipack5 = false
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_extrabonuspack2')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}
----------------------------------------------
------------MOD CODE END----------------------