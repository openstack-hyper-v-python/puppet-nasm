class nasm (
    $version     = $swig::params::version,
    $url         = $swig::params::url,
    $package     = $swig::params:package,
    $nasmpath    = $swig::params::nasmpath,
) inherits nasm::params {
    windows_common::remote_file{"nasm":
        source      => "${url}",
        destination => "${nasmpath}\\${package}-${version}.zip",
        before      => Windows_7zip::Extract_file['nasm'],
        require     => File["${$nasm}"],
    }
    
    windows_7zip::extract_file{'nasm':
        file        => "${nasmpath}\\${package}-${version}.zip",
        destination => $nasmpath,
        before      => windows_path['nasm'],
        subscribe   => Windows_common::Remote_file["nasm"],
    }
    
    windows_path{ $nasmpath:
        ensure      => present,
        require     Windows_7zip::Extract_file['nasm'],
    }
}