--[[
Bullet = {
	Mat = {},
	Contents = {},
	Ric = {
		"weapons/fx/rics/ric1.wav",
		"weapons/fx/rics/ric2.wav",
		"weapons/fx/rics/ric3.wav",
		"weapons/fx/rics/ric4.wav",
		"weapons/fx/rics/ric5.wav"
	},
	NearMiss = {
		"weapons/fx/nearmiss/bulletltor03.wav",
		"weapons/fx/nearmiss/bulletltor04.wav",
		"weapons/fx/nearmiss/bulletltor05.wav",
		"weapons/fx/nearmiss/bulletltor06.wav",
		"weapons/fx/nearmiss/bulletltor07.wav",
		"weapons/fx/nearmiss/bulletltor09.wav",
		"weapons/fx/nearmiss/bulletltor10.wav",
		"weapons/fx/nearmiss/bulletltor11.wav",
		"weapons/fx/nearmiss/bulletltor12.wav",
		"weapons/fx/nearmiss/bulletltor13.wav",
		"weapons/fx/nearmiss/bulletltor14.wav"
	},
	Sounds = {
		Rubber = {
			"physics/rubber/rubber_tire_impact_bullet1.wav",
			"physics/rubber/rubber_tire_impact_bullet2.wav",
			"physics/rubber/rubber_tire_impact_bullet3.wav"
		},
		Cardboard = {
			"physics/cardboard/cardboard_box_impact_bullet1.wav",
			"physics/cardboard/cardboard_box_impact_bullet2.wav",
			"physics/cardboard/cardboard_box_impact_bullet3.wav",
			"physics/cardboard/cardboard_box_impact_bullet4.wav",
			"physics/cardboard/cardboard_box_impact_bullet5.wav"
		}
	},
	Effects = {
		Wake = "particle/particle_swirl_03"
	}
}

Bullet.Mat[MAT_METAL] = {
	Penetrate = 1,
	Ricochet = 32,
	Sounds = {
		World = {
			"physics/metal/metal_solid_impact_bullet1.wav",
			"physics/metal/metal_solid_impact_bullet2.wav",
			"physics/metal/metal_solid_impact_bullet3.wav",
			"physics/metal/metal_solid_impact_bullet4.wav"
		},
		Box = {
			"physics/metal/metal_box_impact_bullet1.wav",
			"physics/metal/metal_box_impact_bullet2.wav",
			"physics/metal/metal_box_impact_bullet3.wav"
		},
		Sheet = {
			"physics/metal/metal_sheet_impact_bullet1.wav",
			"physics/metal/metal_sheet_impact_bullet2.wav"
		}
	},
	Decals = {
		"decals/metal/shot1",
		"decals/metal/shot2",
		"decals/metal/shot3",
		"decals/metal/shot4",
		"decals/metal/shot5"
	},
	Effects = {
		"Sparks",
		"MetalSpark"
	}
}
Bullet.Mat[MAT_WOOD] = {
	Penetrate = 4.65,
	Ricochet = 8,
	Sounds = {
		World = {
			"physics/wood/wood_solid_impact_bullet1.wav",
			"physics/wood/wood_solid_impact_bullet2.wav",
			"physics/wood/wood_solid_impact_bullet3.wav",
			"physics/wood/wood_solid_impact_bullet4.wav",
			"physics/wood/wood_solid_impact_bullet5.wav"
		},
		Box = {
			"physics/wood/wood_box_impact_bullet1.wav",
			"physics/wood/wood_box_impact_bullet2.wav",
			"physics/wood/wood_box_impact_bullet3.wav",
			"physics/wood/wood_box_impact_bullet4.wav"
		}
	},
	Decals = {
		"decals/wood/shot1",
		"decals/wood/shot2",
		"decals/wood/shot3",
		"decals/wood/shot4",
		"decals/wood/shot5"
	},
	Effects = {
		"effects/fleck_wood1",
		"effects/fleck_wood2"
	}
}
Bullet.Mat[MAT_CONCRETE] = {
	Penetrate = 2.25,
	Ricochet = 16,
	Sounds = {
		"physics/concrete/concrete_impact_bullet1.wav",
		"physics/concrete/concrete_impact_bullet2.wav",
		"physics/concrete/concrete_impact_bullet3.wav",
		"physics/concrete/concrete_impact_bullet4.wav"
	},
	Decals = {},
	Effects = {
		"effects/fleck_cement1",
		"effects/fleck_cement2"
	}
}
Bullet.Mat[MAT_TILE] = {
	Penetrate = 4.86,
	Ricochet = 22,
	Sounds = {
		"physics/surfaces/tile_impact_bullet1.wav",
		"physics/surfaces/tile_impact_bullet2.wav",
		"physics/surfaces/tile_impact_bullet3.wav",
		"physics/surfaces/tile_impact_bullet4.wav"
	},
	Decals = {},
	Effects = {
		"effects/fleck_tile1",
		"effects/fleck_tile2"
	}
}
Bullet.Mat[MAT_PLASTIC] = {
	Penetrate = 8.75,
	Ricochet = 5,
	Sounds = {
		Box = {
			"physics/plastic/plastic_box_impact_bullet1.wav",
			"physics/plastic/plastic_box_impact_bullet2.wav",
			"physics/plastic/plastic_box_impact_bullet3.wav",
			"physics/plastic/plastic_box_impact_bullet4.wav",
			"physics/plastic/plastic_box_impact_bullet5.wav"
		},
		Barrel = {
			"physics/plastic/plastic_barrel_impact_bullet1.wav",
			"physics/plastic/plastic_barrel_impact_bullet2.wav",
			"physics/plastic/plastic_barrel_impact_bullet3.wav"
		}
	},
	Decals = {},
	Effects = {
		"effects/fleck_tile1",
		"effects/fleck_tile2"
	}
}
Bullet.Mat[MAT_GLASS] = {
	Penetrate = 6.76,
	Ricochet = 4,
	Sounds = {
		"physics/glass/glass_impact_bullet1.wav",
		"physics/glass/glass_impact_bullet2.wav",
		"physics/glass/glass_impact_bullet3.wav",
		"physics/glass/glass_impact_bullet4.wav"
	},
	Decals = {
		"decals/glass/shot1",
		"decals/glass/shot2",
		"decals/glass/shot3",
		"decals/glass/shot4",
		"decals/glass/shot5"
	},
	Effects = {
		"effects/fleck_glass1",
		"effects/fleck_glass2",
		"effects/fleck_glass3",
		"GlassImpact"
	}
}
Bullet.Mat[MAT_FLESH] = {
	Penetrate = 12.96,
	Ricochet = false,
	Sounds = {
		Bone = {
			"physics/flesh/flesh_bloody_break.wav",
			"physics/body/body_medium_break4.wav",
			"npc/barnacle/neck_snap1.wav",
			"npc/barnacle/neck_snap2.wav"
		},
		Flesh = {
			"physics/flesh/flesh_impact_bullet1.wav",
			"physics/flesh/flesh_impact_bullet2.wav",
			"physics/flesh/flesh_impact_bullet3.wav",
			"physics/flesh/flesh_impact_bullet4.wav",
			"physics/flesh/flesh_impact_bullet5.wav"
		}
	},
	Decals = {
		WallSpray = {
			"decals/blood_stain001",
			"decals/blood_stain002",
			"decals/blood_stain003",
			"decals/blood_stain003b",
			"decals/blood_stain101"
		},
		EntSpray = {
			"decals/blood1",
			"decals/blood2",
			"decals/blood3",
			"decals/blood4",
			"decals/blood5",
			"decals/blood6",
			"decals/blood7",
			"decals/blood8"
		},
		FleshHit = {
			"decals/flesh/blood1",
			"decals/flesh/blood2",
			"decals/flesh/blood3",
			"decals/flesh/blood4",
			"decals/flesh/blood5"
		}
	},
	Effects = {
		"particle/blood_core",
		"bloodsplash",
		"bodyshot",
		"BloodImpact"
	}
}
Bullet.Mat[MAT_ALIENFLESH] = Bullet.Mat[MAT_FLESH]
Bullet.Mat[MAT_BLOODYFLESH] = Bullet.Mat[MAT_FLESH]
Bullet.Mat[MAT_COMPUTER] = {
	Penetrate = 4.15,
	Ricochet = 44,
	Sounds = {
		"physics/metal/metal_computer_impact_bullet1.wav",
		"physics/metal/metal_computer_impact_bullet2.wav",
		"physics/metal/metal_computer_impact_bullet3.wav"
	},
	Decals = {},
	Effects = {
		"Sparks"
	}
}
Bullet.Mat[MAT_VENT] = {
	Penetrate = 6.8,
	Ricochet = 35,
	Sounds = {
		"physics/metal/metal_sheet_impact_bullet1.wav",
		"physics/metal/metal_sheet_impact_bullet2.wav"
	},
	Decals = {
		"decals/metal/shot1",
		"decals/metal/shot2",
		"decals/metal/shot3",
		"decals/metal/shot4",
		"decals/metal/shot5"
	},
	Effects = {
		"Sparks",
		"MetalSpark"
	}
}
Bullet.Contents[CONTENTS_WATER] = {
	Penetrate = 1.2,
	Ricochet = false,
	Sounds = {
		"physics/surfaces/underwater_impact_bullet1.wav",
		"physics/surfaces/underwater_impact_bullet2.wav",
		"physics/surfaces/underwater_impact_bullet3.wav"
	},
	Decals = {},
	Effects = {}
}
Bullet.Mat[MAT_GRATE] = {
	Penetrate = true,
	Ricochet = false,
	Sounds = {
		"physics/metal/metal_grate_impact_hard1.wav",
		"physics/metal/metal_grate_impact_hard2.wav",
		"physics/metal/metal_grate_impact_hard3.wav"
	},
	Decals = {
		"decals/metal/shot1",
		"decals/metal/shot2",
		"decals/metal/shot3",
		"decals/metal/shot4",
		"decals/metal/shot5"
	},
	Effects = {
		"Sparks",
		"MetalSpark"
	}
}
Bullet.Mat[MAT_FOLIAGE] = {
	Penetrate = true,
	Ricochet = false,
	Sounds = {
		"physics/wood/wood_strain2.wav",
		"physics/wood/wood_strain3.wav",
		"physics/wood/wood_strain4.wav"
	},
	Decals = {},
	Effects = {}
}
Bullet.Mat[MAT_DIRT] = {
	Penetrate = false,
	Ricochet = 2,
	Sounds = {
		"physics/surfaces/sand_impact_bullet1.wav",
		"physics/surfaces/sand_impact_bullet2.wav",
		"physics/surfaces/sand_impact_bullet3.wav",
		"physics/surfaces/sand_impact_bullet4.wav"
	},
	Decals = {},
	Effects = {}
}
Bullet.Mat[MAT_SAND] = Bullet.Mat[MAT_DIRT]
Bullet.Mat[MAT_SLOSH] = Bullet.Contents[CONTENTS_WATER]

Bullet.Mat[-1] = {
	Penetrate = 1,
	Ricochet = 33,
	Sounds = {
		"physics/concrete/concrete_impact_bullet1.wav",
		"physics/concrete/concrete_impact_bullet2.wav",
		"physics/concrete/concrete_impact_bullet3.wav",
		"physics/concrete/concrete_impact_bullet4.wav"
	},
	Decals = {
		Ent = {
			"decals/bigshot1model",
			"decals/bigshot2model",
			"decals/bigshot3model",
			"decals/bigshot4model",
			"decals/bigshot5model"
		},
		World = {
			"decals/bigshot1",
			"decals/bigshot2",
			"decals/bigshot3",
			"decals/bigshot4",
			"decals/bigshot5"
		}
	},
	Effects = {"Impact"}
}
]]
