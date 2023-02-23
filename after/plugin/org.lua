-- Load custom treesitter grammar for org filetype
require('orgmode').setup_ts_grammar()

require('orgmode').setup({
  --org_agenda_files = {'path/to/files/*', 'path/to/other/location/*'},
  --org_default_notes_file = 'path/to/default/file.org',
  org_todo_keywords = {'TODO', 'NEXT', '|', 'DONE', 'CANCELLED'}
})
