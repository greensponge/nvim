return {
	"ahmedkhalf/project.nvim",
	-- can't use 'opts' because module has non standard name 'project_nvim'
	config = function()
		require("project_nvim").setup()
	end
}
