return {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- 文件图标
    },
    config = function()
      require'nvim-tree'.setup {}
    end
  }