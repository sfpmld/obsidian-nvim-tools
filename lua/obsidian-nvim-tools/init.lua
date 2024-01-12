local vim = vim
local M = {}

-- Define function to get current buffer
local getCurrentBuffer = function()
  local current_buffer = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  return current_buffer
end

-- Define the function to convert titles to wiki links
local convertTitlesToWikiLinks = function(header)
  -- set default header
  if header == nil then
    header = '#'
  end
  local header_length = string.len(header)
  local current_buffer = getCurrentBuffer()

  for line_num, line_content in ipairs(current_buffer) do
    if string.sub(line_content, 1, header_length) == header then
      local title = string.sub(line_content, header_length)
      title = title:match('^%s*(.-)%s*$')

      if not string.match(title, '%[%[.*%]%]') then
        local wiki_link = '[[' .. title .. ']]'
        current_buffer[line_num] = wiki_link
      end
    end
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, current_buffer)
end

-- Define the function to convert h1 to wiki links
M.convertH1ToWikiLinks = function()
  convertTitlesToWikiLinks('#')
end

-- Define the function to convert h2 to wiki links
M.convertH2ToWikiLinks = function()
  convertTitlesToWikiLinks('##')
end

-- Define the function to convert h3 to wiki links
M.convertH3ToWikiLinks = function()
  convertTitlesToWikiLinks('###')
end

-- Define the function to convert h4 to wiki links
M.convertH4ToWikiLinks = function()
  convertTitlesToWikiLinks('####')
end

return M
