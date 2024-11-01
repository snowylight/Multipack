--- STEAMODDED HEADER
--- MOD_NAME: Multipack
--- MOD_ID: Multipack
--- MOD_AUTHOR: [sishui]
--- MOD_DESCRIPTION: Multipack
--- BADGE_COLOUR: 9932CC
--- PREFIX: mupack
--- VERSION: 1.1.0
----------------------------------------------
------------MOD CODE -------------------------
SMODS.Atlas({key = 'mupack', path = 'multipacks1.png', px = 71, py = 95 })
SMODS.Atlas({key = 'freemupack', path = 'multipacks2.png', px = 71, py = 95 })

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
          card_eval_status_text(c1, 'extra', nil, nil, nil, {message = "Add to shop", colour = G.C.MULT})
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

SMODS.Booster{
    key = "multipack1",
    atlas = 'mupack',
    pos = {x = 0, y = 0},
    weight = 0.8,
    cost = 2,
    config = {extra = 3, choose = 1},
    discovered = true,
    loc_txt ={
        name = 'Multiple Pack',
        text = {
            "Choose {C:attention}1{} of up to",
            "{C:attention}3{C:attention} Booster Packs{} to",
            "add to your shop"
        }
    },
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
                                {n=G.UIT.O, config={object = DynaText({string = 'Multiple Pack', colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
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
    atlas = 'mupack',
    pos = {x = 1, y = 0},
    weight = 0.6,
    cost = 3,
    config = {extra = 4, choose = 2},
    discovered = true,
    loc_txt ={
        name = 'Jumbo Multiple Pack',
        text = {
            "Choose {C:attention}2{} of up to",
            "{C:attention}4{C:attention} Booster Packs{} to",
            "add to your shop"
        }
    },
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
                                {n=G.UIT.O, config={object = DynaText({string = 'Multiple Pack', colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
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
    atlas = 'mupack',
    pos = {x = 2, y = 0},
    weight = 0.5,
    cost = 4,
    config = {extra = 5, choose = 3},
    discovered = true,
    loc_txt ={
        name = 'Mega Multiple Pack',
        text = {
            "Choose {C:attention}3{} of up to",
            "{C:attention}5{C:attention} Booster Packs{} to",
            "add to your shop"
        }
    },
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
                                {n=G.UIT.O, config={object = DynaText({string = 'Multiple Pack', colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
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
    atlas = 'freemupack',
    pos = {x = 0, y = 0},
    weight = 0.5,
    cost = 6,
    config = {extra = 4, choose = 2},
    discovered = true,
    loc_txt ={
        name = 'Discounted Multiple Pack',
        text = {
            "Choose {C:attention}2{} of up to",
            "{C:attention}4{C:attention} Booster Packs{} to",
            "add to your shop",
            "They will be {C:attention}50%{} off"
        }
    },
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
                                {n=G.UIT.O, config={object = DynaText({string = 'Multiple Pack', colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
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
    atlas = 'freemupack',
    pos = {x = 1, y = 0},
    weight = 0.5,
    cost = 8,
    config = {extra = 5, choose = 2},
    discovered = true,
    loc_txt ={
        name = 'Free Multiple Pack',
        text = {
            "Choose {C:attention}2{} of up to",
            "{C:attention}5{C:attention} Booster Packs{} to",
            "add to your shop",
            "They can be opened for {C:attention}Free{}"
        }
    },
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
                                {n=G.UIT.O, config={object = DynaText({string = 'Multiple Pack', colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
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