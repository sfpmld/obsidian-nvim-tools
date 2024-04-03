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
      local title = string.sub(line_content, header_length + 1)
      title = title:match('^%s*(.-)%s*$')

      if not string.match(title, '%[%[.*%]%]') then
        local wiki_link = header .. ' ' .. '[[' .. title .. ']]'
        current_buffer[line_num] = wiki_link
      end
    end
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, current_buffer)
end

-- Define the function that converts all kindle uri links into live kindle links
local convertKindleUriToLiveLinks = function()
  local current_buffer = getCurrentBuffer()
  local matches = 'kindle://book%?action=open&asin=(%w-)&location=(%d+)'
  local livekindle = 'https://lire.amazon.fr?asin=%s&location=%s'

  for line_num, line_content in ipairs(current_buffer) do
    for asin, location in string.gmatch(line_content, matches) do
      if asin == nil or location == nil then
        return
      end
      local live_link = string.format(livekindle, asin, location)
      current_buffer[line_num] = string.gsub(line_content, matches, live_link)
    end
  end

  local main_uri_matches = 'kindle://book%?action=open&asin=(%w-)'
  local main_livekindle = 'https://lire.amazon.fr?asin=%s'

  for line_num, line_content in ipairs(current_buffer) do
    for asin in string.gmatch(line_content, main_uri_matches) do
      if asin == nil then
        return
      end
      local live_link = string.format(main_livekindle, asin)

      current_buffer[line_num] = string.gsub(line_content, main_uri_matches, live_link)
    end
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, current_buffer)
end

local convertBackLiveLinksToKindleUris = function()
  local current_buffer = getCurrentBuffer()

  -- Define the matches and corresponding replacements for rolling back the changes
  local matches = 'https://lire.amazon.fr%?asin=(%w-)&location=(%d+)'
  local kindle_uri = 'kindle://book?action=open&asin=%s&location=%s'

  -- Rollback the changes made to live links back to Kindle URIs
  for line_num, line_content in ipairs(current_buffer) do
    for asin, location in string.gmatch(line_content, matches) do
      if asin == nil or location == nil then
        return
      end
      local rollback_uri = string.format(kindle_uri, asin, location)

      current_buffer[line_num] = string.gsub(line_content, matches, rollback_uri)
    end
  end

  local main_matches = 'https://lire.amazon.fr%?asin=(%w-)'
  local main_kindle_uri = 'kindle://book?action=open&asin=%s'

  -- Rollback the changes made to main URIs back to Kindle URIs
  for line_num, line_content in ipairs(current_buffer) do
    for asin in string.gmatch(line_content, main_matches) do
      if asin == nil then
        return
      end
      local rollback_uri = string.format(main_kindle_uri, asin)
      current_buffer[line_num] = string.gsub(line_content, main_matches, rollback_uri)
    end
  end

  -- Restore the original URIs in the buffer
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

-- Define kindle uri to live links
M.convertKindleUriToLiveLinks = function()
  convertKindleUriToLiveLinks()
end

M.convertBackLiveLinksToKindleUris = function()
  convertBackLiveLinksToKindleUris()
end

return M
