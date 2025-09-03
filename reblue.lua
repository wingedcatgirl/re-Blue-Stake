SMODS.Stake:take_ownership("stake_blue",{
    modifiers = function ()
        G.GAME.showdown_rate = (G.GAME.showdown_rate or 1) * 2
    end
})