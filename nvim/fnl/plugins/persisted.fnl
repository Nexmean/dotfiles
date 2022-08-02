{
  :from   :olimorris/persisted.nvim
  :config #(let
    [persisted (require :persisted)]
    (persisted.setup {
      :autoload       true
      :use_git_branch true
      :before_save    #(let
        [bufname   (vim.fn.bufname)
         last-tab? (= 1 (vim.fn.tabpagenr :$))]
        (when (or (= bufname :NeogitStatus) (= bufname :NeogitCommitView))
          (if last-tab?
            (pcall vim.cmd :tabnew)
            (pcall vim.cmd :tabclose)
          )
        )
        (pcall vim.cmd "bw NeogitStatus")
        (pcall vim.cmd "bw NeogitCommitView")
      )
    })
  )
}
