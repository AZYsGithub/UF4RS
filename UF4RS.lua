-- Environment Setup
-- You also can use existing path to implement the fs inside the folder

ROOTFS_NAME = "rootfs"
ROOTFS_PARENT = game.ReplicatedStorage

-- Don't modify it if you don't know what are you doing, or it will break lol.
local ROOTFS_FOLDER = ROOTFS_PARENT[ROOTFS_NAME] or Instance.new("Folder", ROOTFS_PARENT)
ROOTFS_FOLDER.Name = ROOTFS_NAME
	function getInstanceFromPath(path)
		if path == "" then
			return ROOT
		end

		local parts = string.split(path, "/")
		local current = ROOT

		for i = 1, #parts do
			current = current:FindFirstChild(parts[i])
			if not current then
				return nil
			end
		end

		return current
	end

	function makefolder(path)
		local parts = string.split(path, "/")
		local current = ROOT

		for i = 1, #parts do
			local folder = current:FindFirstChild(parts[i])
			if not folder then
				folder = Instance.new("Folder")
				folder.Name = parts[i]
				folder.Parent = current
			elseif not folder:IsA("Folder") then
				error("Path exists but is not a folder.")
			end
			current = folder
		end
	end

	function writefile(path, content)
		local parentFolderPath = path:match("(.+)/[^/]+$") or ""
		local fileName = path:match("[^/]+$")

		local folder = getInstanceFromPath(parentFolderPath)

		if folder then
			local file = folder:FindFirstChild(fileName) or Instance.new("StringValue")
			file.Name = fileName
			file.Value = content
			file.Parent = folder
		else
			error("Invalid path.")
		end
	end

	function readfile(path)
		local file = getInstanceFromPath(path)
		if file and file:IsA("StringValue") then
			return file.Value
		else
			error("File not found.")
		end
	end

	function loadfile(path)
		local file = getInstanceFromPath(path)
		if file and file:IsA("StringValue") then
			return loadstring(file.Value)
		else
			error("File not found.")
		end
	end

	function dofile(path)
		local file = getInstanceFromPath(path)
		if file and file:IsA("StringValue") then
			return loadstring(file.Value)()
		else
			error("File not found.")
		end
	end

	function appendfile(path, content)
		local existingContent = ""
		local file = getInstanceFromPath(path)

		if file and file:IsA("StringValue") then
			existingContent = file.Value
		else
			makefolder(path:match("(.+)/[^/]+$") or "")
			writefile(path, content)
			return
		end

		local newContent = existingContent .. content
		writefile(path, newContent)
	end

	function listfiles(folder)
		local folderInstance = getInstanceFromPath(folder)
		if folderInstance and folderInstance:IsA("Folder") then
			local files = {}
			for _, child in pairs(folderInstance:GetChildren()) do
				table.insert(files, folder.."/"..child.Name)
			end
			return files
		else
			error("Folder not found.")
		end
	end

	function isfolder(path)
		local folder = getInstanceFromPath(path)
		return folder and folder:IsA("Folder") or false
	end

	function isfile(path)
		local file = getInstanceFromPath(path)
		return file and file:IsA("StringValue") or false
	end

	function delfile(path)
		local file = getInstanceFromPath(path)
		if file and file:IsA("StringValue") then
			file:Destroy()
		else
			error("File not found.")
		end
	end

	function delfolder(path)
		local folder = getInstanceFromPath(path)
		if folder and folder:IsA("Folder") then
			folder:Destroy()
		else
			error("Folder not found.")
		end
	end
