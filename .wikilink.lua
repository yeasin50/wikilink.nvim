return {
	extension = "md",
	featurePattern = "%[%[([%w%-%_/%s]+)%]%]", -- default feature link pattern
	tagPattern = "#([%w%-_]+)", -- default tag pattern
	featureLoc = "test/project_features", -- relative path from project root
	tagLoc = "test/project_tags", -- relative path from project root
	wikilink = true, -- enable wikilink globally by default
}
