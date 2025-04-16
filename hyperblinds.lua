--- STEAMODDED HEADER
--- MOD_NAME: Hyperblinds Test
--- MOD_ID: hyperblinds
--- MOD_AUTHOR: [arnideus]
--- MOD_DESCRIPTION: ughhh ahhh ooooooh ahhh ahhh ahhh

----------------------------------------------
------------MOD CODE -------------------------

--NOTHING IS COMPATIBLE WITH MATADOR CHANGE IT!!!!!!!!!!!!!!!!!!!!!!
SMODS.Atlas({
    key = 'hyperatlas',
    path = 'blinds.png',
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
    px = 34,
    py = 34
})


SMODS.Blind({
    -- the hook
    loc_txt = {
        name = 'HB-209 "SKEWER"',
        text = { 'All cards held in hand','are destroyed when','a hand is played' }
    },
    key = 'skewer',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    boss = {min = 9, max = 10},
    boss_colour = HEX('646464'),
    config = {played_hands = 0},
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    press_play = function(self)
        local mem_select_limit = G.hand.config.highlighted_limit
        local any_selected = nil
        G.E_MANAGER:add_event(Event({ func = function()
            
            G.hand.config.highlighted_limit = math.huge
            for k, v in ipairs(G.hand.cards) do
                G.hand:add_to_highlighted(G.hand.cards[k], true)
                any_selected = true
                play_sound('card1', 1)
            end
            
        return true end }))

        delay(0.85)

        G.E_MANAGER:add_event(Event({ func = function()
        if any_selected then
            for i=#G.hand.highlighted, 1, -1 do
                local card = G.hand.highlighted[i]
                if card.ability.name == 'Glass Card' then 
                    card:shatter()
                else
                    card:start_dissolve(nil, i == #G.hand.highlighted)
                end
            end
        end
        return true end })) 
        G.hand.config.highlighted_limit = mem_select_limit
        
    end,
})


SMODS.Blind({
    --the wall
    loc_txt = {
        name = 'HB-018 "SUMMIT"',
        text = { 'Extremely Large Blind' }
    },
    key = 'summit',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 16,
    boss = {min = 9, max = 10},
    boss_colour = HEX('AC66CF'),
    config = { },
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
})


SMODS.Blind({
    --the pillar
    loc_txt = {
        name = 'HB-926 "MARBLE"',
        text = { 'All cards played','previously are debuffed' }
    },
    key = 'marble',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    boss = {min = 9, max = 10},
    boss_colour = HEX('AC66CF'),
    config = { },
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    debuff_card = function(self, card, from_blind)
        if card.base.times_played ~= 0 then
            return true
        end
    end,
})


SMODS.Blind({
    --the weel
    loc_txt = {
        name = 'HB-373 "BLIND"',
        text = { 'All cards are','drawn face down' }
    },
    key = 'blind',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    boss = {min = 9, max = 10},
    boss_colour = HEX('646464'),
    config = {played_hands = 0},
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    stay_flipped = function(self, area, card)
        if area == G.hand then return true end
    end
})

SMODS.Blind({
    --the club
    loc_txt = {
        name = 'HB-300 "MACE"',
        text = { 'Destroys all Club','cards in deck','when entered' }
    },
    key = 'mace',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 3,
    boss = {min = 9, max = 10},
    boss_colour = HEX('646464'),
    config = {extra = { }},
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    set_blind = function (self, reset, silent)
        for k,v in ipairs(G.deck.cards) do
            if v:is_suit('Clubs') then
                v:start_dissolve()
            end
        end
    end
})

SMODS.Blind({
    --the fish
    loc_txt = {
        name = 'HB-707 "AHAB"',
        text = { 'All hands are drawn','face down and debuffed','except for your first' }
    },
    key = 'ahab',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 4,
    boss = {min = 9, max = 10},
    boss_colour = HEX('646464'),
    config = {active = false},
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    drawn_to_hand = function(self)
        self.config.active = true
    end,
    stay_flipped = function(self, area, card)
        if self.config.active and area == G.hand then 
            card:set_debuff(true)
            return true 
        end 
    end,
    defeat = function(self)
        self.config.active = false
    end,
})

SMODS.Blind({
    ---todo bugtest this with hand size changes mid round
    loc_txt = {
        name = 'HB-555 "THAUMATURGE"',
        text = { 'Hand size is set to 5', 'Must play 5 cards' }
    },
    key = 'thaumaturge',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    boss = {min = 9, max = 10},
    boss_colour = HEX('646464'),
    config = { old_hand_size = nil },
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    set_blind = function (self, reset, silent)
        self.debuff.h_size_ge = 5
        self.debuff.h_size_le = 5
        self.config.old_hand_size = G.hand.config.card_limit
        G.hand:change_size(5 - G.hand.config.card_limit)
    end,
    defeat = function(self)
        G.hand:change_size(self.config.old_hand_size - 5)
    end,
})


SMODS.Blind({
    loc_txt = {
        name = 'HB-100 "SPUR"',
        text = { 'Destroys all Spade','cards in deck','when entered' }
    },
    key = 'spur',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 3,
    boss = {min = 9, max = 10},
    boss_colour = HEX('646464'),
    config = {extra = { }},
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    set_blind = function (self, reset, silent)
        for k,v in ipairs(G.deck.cards) do
            if v:is_suit('Spades') then
                v:start_dissolve()
            end
        end
    end
})

SMODS.Blind({
    loc_txt = {
        name = 'HB-400 "FISSURE"',
        text = { 'Destroys all Diamond','cards in deck','when entered' }
    },
    key = 'fissure',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 3,
    boss = {min = 9, max = 10},
    boss_colour = HEX('646464'),
    config = {extra = { }},
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    set_blind = function (self, reset, silent)
        for k,v in ipairs(G.deck.cards) do
            if v:is_suit('Diamonds') then
                v:start_dissolve()
            end
        end
    end
})

SMODS.Blind({
    --the serpent
    loc_txt = {
        name = 'HB-019 "CONSTRICTOR"',
        text = { 'After Play or Discard', 'always draw 1 card' }
    },
    key = 'constrictor',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    boss = {min = 9, max = 10},
    boss_colour = HEX('646464'),
    config = {extra = { }},
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
})

SMODS.Blind({
    loc_txt = {
        name = 'HB-301 "THREAD"',
        text = { 'Unused hands are','permanently removed' }
    },
    key = 'thread',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    boss = {min = 9, max = 10},
    boss_colour = HEX('646464'),
    config = {played_hands = 0},
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    defeat = function(self)
        ease_hands_played(G.GAME.current_round.hands_played-G.GAME.round_resets.hands)
        G.GAME.round_resets.hands = G.GAME.current_round.hands_played
    end
})

SMODS.Blind({
    --head
    loc_txt = {
        name = 'HB-200 "SKULL"',
        text = { 'Destroys all Heart','cards in deck','when entered' }
    },
    key = 'skull',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 3,
    boss = {min = 9, max = 10},
    boss_colour = HEX('646464'),
    config = {extra = { }},
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    set_blind = function (self, reset, silent)
        for k,v in ipairs(G.deck.cards) do
            if v:is_suit('Hearts') then
                v:start_dissolve()
            end
        end
    end
})



SMODS.Blind({
    loc_txt = {
        name = 'HB-076 "JAWLINE"',
        text = { 'Final Chips and Mult','are divided by your $' }
    },
    key = 'jawline',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 3,
    boss = {min = 9, max = 10},
    boss_colour = HEX('646464'),
    config = { },
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    
})


SMODS.Blind({
    --the mark
    loc_txt = {
        name = 'HB-500 "SCAB"',
        text = { 'Destroys all Face','cards in deck','when entered' }
    },
    key = 'scab',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 3,
    boss = {min = 9, max = 10},
    boss_colour = HEX('646464'),
    config = {extra = { }},
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    set_blind = function (self, reset, silent)
        for k,v in ipairs(G.deck.cards) do
            if v:is_face() then
                v:start_dissolve()
            end
        end
    end
})


SMODS.Blind({
    --cerulean bell
    loc_txt = {
        name = 'HSB-8853 "ALL-IN"',
        text = { 'Entire hand', 'forcibly selected' }
    },
    key = 'allin',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    boss = {min = 9, max = 10},
    showdown = true,
    boss_colour = HEX('646464'),
    config = { chosen_hand = nil } ,
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    drawn_to_hand = function(self)
        local mem_select_limit = G.hand.config.highlighted_limit
        G.E_MANAGER:add_event(Event({ func = function()
            
            G.hand.config.highlighted_limit = math.huge
            for k, v in ipairs(G.hand.cards) do
                G.hand.cards[k].ability.forced_selection = true
                G.hand:add_to_highlighted(G.hand.cards[k], true)
                play_sound('card1', 1)
            end
            
        return true end }))
        G.hand.config.highlighted_limit = mem_select_limit
    end,
})


SMODS.Blind({
    --turquoise tornado
    loc_txt = {
        name = 'HSB-5448 "TYPHOON"',
        text = { 'Sets Hands to 10', 'Only one random Hand will score' }
    },
    key = 'typhoon',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    boss = {min = 9, max = 10},
    showdown = true,
    boss_colour = HEX('646464'),
    config = { chosen_hand = nil } ,
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    set_blind = function (self, reset, silent)
        self.config.chosen_hand = pseudorandom('typhoon', 0,9)
        ease_hands_played(10-G.GAME.round_resets.hands)
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        if G.GAME.current_round.hands_played ~= self.config.chosen_hand and not check then
            return true
        end
    end,
})

-- these blinds are buggy and not enabled ingame


SMODS.Blind({
    --TODO make handsize change work before you draw cards
    loc_txt = {
        name = 'HB-010 "HANDCUFF"',
        text = { 'Hand Size is reduced', 'to the number of', 'Hands and Discards left','(CURRENTLY BUGGED)' }
    },
    key = 'summit',
    atlas = 'hyperatlas',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 4,
    boss = {min = 9, max = 10},
    boss_colour = HEX('646464'),
    config = {old_hand_size = nil},
    loc_vars = function(self, info_queue, card)
        return { }
    end,
    collection_loc_vars = function(self)
        return { }
    end,
    set_blind = function(self, reset, silent)
        self.config.old_hand_size = G.hand.config.card_limit
    end,
    drawn_to_hand = function(self)
        G.hand.config.card_limit = math.min(self.config.old_hand_size, G.GAME.current_round.hands_left + G.GAME.current_round.discards_left)
    end,
    defeat = function(self)
        G.hand.config.card_limit = self.config.old_hand_size
    end,
})

-----------
------------MOD CODE END----------------------

-----------------------------------