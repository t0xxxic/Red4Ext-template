function getFolderName(path)
    -- Match the last part of the path after the final slash
    local folderName = path:match("^.+/(.+)$")
    return folderName
end

local path = os.getcwd()
local folderName = getFolderName(path)

-- premake5.lua
workspace "RED4Script"
   architecture "x64"
   configurations { "Debug", "Release", "Dist" }
   startproject (folderName)

   -- Workspace-wide build options for MSVC
   filter "system:windows"
      buildoptions { "/EHsc", "/Zc:preprocessor", "/Zc:__cplusplus" }

OutputDir = "%{cfg.system}-%{cfg.architecture}/%{cfg.buildcfg}"


project (folderName)
   kind "SharedLib"
   language "C++"
   targetdir "Binaries/%{cfg.buildcfg}"
   cppdialect "c++20"
   staticruntime "off"
   toolset "msc"

   files { "src/**.h", 
            "src/**.cpp" }

   includedirs
   {
      "sdk/red4ext-sdk/include/",
      "src",
   }

   libdirs {}

   links
   {

   }

   targetdir ("./bin/" .. OutputDir .. "/%{prj.name}")
   objdir ("./bin/int/" .. OutputDir .. "/%{prj.name}")

   filter "system:windows"
       systemversion "latest"
       defines { "WINDOWS" }

   filter "configurations:Debug"
       defines { "DEBUG" }
       runtime "Debug"
       symbols "On"

   filter "configurations:Release"
       defines { "RELEASE" }
       runtime "Release"
       optimize "On"
       symbols "On"

   filter "configurations:Dist"
       defines { "DIST" }
       runtime "Release"
       optimize "On"
       symbols "Off"