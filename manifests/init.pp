class nasm (
    $version     = $nasm::params::version,
    $url         = $nasm::params::url,
    $package     = $nasm::params::package,
    $nasmpath    = $nasm::params::nasmpath,
) inherits nasm::params {
    windows_common::remote_file{'nasm':
        source      => "${url}",
        destination => "${nasmpath}\\${package}-${version}.zip",
        before      => Windows_7zip::Extract_file['nasm'],
        require     => File["${nasmpath}"],
    }
    
    file {"${nasmpath}":
      ensure => directory,
    }
    
    windows_7zip::extract_file{'nasm':
        file        => "${nasmpath}\\${package}-${version}.zip",
        destination => $nasmpath,
        before      => [File["${nasmpath}/nasmw.exe"], windows_path["$nasmpath"]],
        subscribe   => Windows_common::Remote_file["nasm"],
    }
    
    file{"${nasmpath}/nasmw.exe":
      ensure => link,
      target => "${nasmpath}/nasm.exe",
        require     => Windows_7zip::Extract_file['nasm'],
    }

    windows_path{ $nasmpath:
        ensure      => present,
        require     => Windows_7zip::Extract_file['nasm'],
    }
}
