NPX.Admin:AddRank("owner", {
    inherits = "dev",
    issuperadmin = true,
    allowafk = true,
    grant = 101
})

NPX.Admin:AddRank("dev", {
    inherits = "spec",
    issuperadmin = true,
    allowafk = true,
    grant = 100
})

NPX.Admin:AddRank("spec", {
    inherits = "admin",
    issuperadmin = true,
    allowafk = true,
    grant = 99
})

NPX.Admin:AddRank("admin", {
    inherits = "moderator",
    allowafk = true,
    isadmin = true,
    grant = 98
})

NPX.Admin:AddRank("moderator", {
    inherits = "trusted",
    isadmin = true,
    grant = 97
})

NPX.Admin:AddRank("trusted", {
    inherits = "user",
    isadmin = true,
    grant = 96
})

NPX.Admin:AddRank("user", {
    inherits = "",
    grant = 1
})