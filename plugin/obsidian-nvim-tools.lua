local vim = vim
local nvim_set_hl, nvim_create_user_command = vim.api.nvim_set_hl, vim.api.nvim_create_user_command

nvim_create_user_command('ObsidianToolsConvertH1ToWikiLinks', function()
  require('obsidian-nvim-tools').convertH1ToWikiLinks()
end, {})

nvim_create_user_command('ObsidianToolsConvertH2ToWikiLinks', function()
  require('obsidian-nvim-tools').convertH2ToWikiLinks()
end, {})

nvim_create_user_command('ObsidianToolsConvertH3ToWikiLinks', function()
  require('obsidian-nvim-tools').convertH3ToWikiLinks()
end, {})

nvim_create_user_command('ObsidianToolsConvertH4ToWikiLinks', function()
  require('obsidian-nvim-tools').convertH4ToWikiLinks()
end, {})
