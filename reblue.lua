local blind_names = { "Random" }
local blind_keys = { "random" }

SMODS.Stake:take_ownership("stake_blue",{
    modifiers = function ()
        G.GAME.showdown_rate = (G.GAME.showdown_rate or 1) * 2
        if REBLUE.config.force_boss.option_value and REBLUE.config.force_boss.option_value ~= "Random" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if not G.GAME.perscribed_bosses then return false end
                        local first = math.ceil(G.GAME.win_ante/G.GAME.showdown_rate)
                        local bosskey
                        for k,v in pairs(G.P_BLINDS) do
                            if localize{type = "name_text", set = "Blind", key = k} == REBLUE.config.force_boss.option_value then bosskey = k break end
                        end
                        G.GAME.perscribed_bosses[first] = bosskey
                        return true
                    end,
                    blocking = false
              }))
        end
    end
})

REBLUE = REBLUE or {}
REBLUE.config = SMODS.current_mod.config

G.FUNCS.reblue_optcycle = function(args)
    local refval = args.cycle_config.ref_value
    REBLUE.config[refval].current_option = args.cycle_config.current_option
    REBLUE.config[refval].option_value = args.to_val
end

SMODS.current_mod.config_tab = function()
    local reset = true
    for k,v in pairs(G.P_BLINDS) do
        if localize{type = "name_text", set = "Blind", key = k} == REBLUE.config.force_boss.option_value then reset = false break end
    end

    if reset then
        REBLUE.config.force_boss = {
            current_option = 1,
            option_value = "Random",
        }
    end

    blind_names = { "Random" }
    blind_keys = { "random" }

    for k,v in pairs(G.P_BLINDS) do
        if v.boss and v.boss.showdown then
            blind_keys[#blind_keys+1] = k
            blind_names[#blind_names+1] = localize{type = "name_text", set = "Blind", key = k}
        end
    end



    return {n = G.UIT.ROOT, config = {r = 0.1, minw = 8, minh = 6, align = "tl", padding = 0.2, colour = G.C.BLACK}, nodes = {
        {n = G.UIT.C, config = {minw=1, minh=1, align = "tl", colour = G.C.CLEAR, padding = 0.15}, nodes = {
        create_option_cycle {
            label = "Force Ante 4 Boss",
            options = blind_names,
            current_option = REBLUE.config.force_boss.current_option,
            ref_table = REBLUE.config,
            ref_value = "force_boss",
            opt_callback = 'reblue_optcycle',
            w = 5.5
            },
        }}
    }}
end