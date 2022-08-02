{
  :from   :nvim-telescope/telescope.nvim
  :cmd    :Telescope
  :after  :persisted
  :config #(let
    [telescope            (require :telescope)
     telescope-sorters    (require :telescope.sorters)
     telescope-previewers (require :telescope.previewers)
     telescope-actions    (require :telescope.actions)]

    (telescope.setup {
      :defaults {
        :vimgrep_arguments [
          :rg
          :--color=never
          :--no-heading
          :--with-filename
          :--line-number
          :--column
          :--smart-case
        ]
        :prompt_prefix      "   "
        :selection_caret    "  "
        :entry_prefix       "  "
        :initial_mode       :insert
        :selection_strategy :reset
        :sorting_strategy   :ascending
        :layout_strategy    :horizontal
        :layout_config {
          :horizontal {
            :prompt_position :top
            :preview_width   0.55
            :results_width   0.8
          }
          :vertical {
            :mirror false
          }
          :width          0.87
          :height         0.80
          :preview_cutoff 120
        }
        :file_sorter            telescope-sorters.get_fuzzy_file
        :file_ignore_patterns   [:node_modules]
        :generic_sorter         telescope-sorters.get_generic_fuzzy_sorter
        :path_display           [:truncate]
        :winblend               0
        :border                 {}
        :borderchars            [:─ :│ :─ :│ :┌ :┐ :┘ :└]
        :color_devicons         true
        :set_env                {:COLORTERM :truecolor} ;; default nil
        :file_previewer         telescope-previewers.vim_buffer_cat.new
        :grep_previewer         telescope-previewers.vim_buffer_vimgrep.new
        :qflist_previewer       telescope-previewers.vim_buffer_qflist.new
        :buffer_previewer_maker telescope-previewers.buffer_previewer_maker
        :mappings {
          :i {:<C-q> telescope-actions.close}
          :n {:<C-q> telescope-actions.close}
        }
      }

      :pickers {
        :buffers {
          :mappings {
            :n {:<C-x> telescope-actions.delete_buffer}
            :i {:<C-x> telescope-actions.delete_buffer}
          }
        }
      }
    })

    (telescope.load_extension :persisted)
  )
}
