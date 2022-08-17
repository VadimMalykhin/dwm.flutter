/// [DwmPlatformVersion]
/// https://docs.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-osversioninfoa
class DwmPlatformVersion {
  static List<DwmPlatformVersion> versions = const [
    DwmPlatformVersion(
      name: 'Windows Vista',
      major: 6,
      minor: 0,
      build: 6000,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows Vista with Service Pack 1',
      major: 6,
      minor: 0,
      build: 6001,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows Server 2008',
      major: 6,
      minor: 0,
      build: 6001,
      isServer: true,
    ),
    DwmPlatformVersion(
      name: 'Windows 7',
      major: 6,
      minor: 1,
      build: 7600,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows Server 2008 R2',
      major: 6,
      minor: 1,
      build: 7600,
      isServer: true,
    ),
    DwmPlatformVersion(
      name: 'Windows 7 with Service Pack 1',
      major: 6,
      minor: 1,
      build: 7601,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows Server 2008 R2 with Service Pack 1',
      major: 6,
      minor: 1,
      build: 7601,
      isServer: true,
    ),
    DwmPlatformVersion(
      name: 'Windows 8',
      major: 6,
      minor: 2,
      build: 9200,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows Server 2012',
      major: 6,
      minor: 2,
      build: 9200,
      isServer: true,
    ),
    DwmPlatformVersion(
      name: 'Windows 8.1',
      major: 6,
      minor: 3,
      build: 9200,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows Server 2012 R2',
      major: 6,
      minor: 3,
      build: 9200,
      isServer: true,
    ),
    DwmPlatformVersion(
      name: 'Windows 8.1 with Update 1',
      major: 6,
      minor: 3,
      build: 9600,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows 10 Version 1507',
      major: 10,
      minor: 0,
      build: 10240,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows 10 Version 1511 (November Update)',
      major: 10,
      minor: 0,
      build: 10586,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows 10 Version 1607 (Anniversary Update)',
      major: 10,
      minor: 0,
      build: 14393,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows Server 2016',
      major: 10,
      minor: 0,
      build: 14393,
      isServer: true,
    ),
    DwmPlatformVersion(
      name: 'Windows 10 Version 1703 (Creators Update)',
      major: 10,
      minor: 0,
      build: 15063,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows 10 Version 1709 (Fall Creators Update)',
      major: 10,
      minor: 0,
      build: 16299,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows 10 Version 1803 (April 2018 Update)',
      major: 10,
      minor: 0,
      build: 17134,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows 10 Version 1809 (October 2018 Update)',
      major: 10,
      minor: 0,
      build: 17763,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows Server 2019',
      major: 10,
      minor: 0,
      build: 17763,
      isServer: true,
    ),
    DwmPlatformVersion(
      name: 'Windows 10 Version 1903 (May 2019 Update)',
      major: 10,
      minor: 0,
      build: 18362,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows 10 Version 1909 (November 2019 Update)',
      major: 10,
      minor: 0,
      build: 18363,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows 10 Version 2004 (May 2020 Update)',
      major: 10,
      minor: 0,
      build: 19041,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows 10 Version 20H2 (October 2020 Update)',
      major: 10,
      minor: 0,
      build: 19042,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows 10 Version 21H1 (May 2021 Update)',
      major: 10,
      minor: 0,
      build: 19043,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows 10 Version 21H2 (November 2021 Update)',
      major: 10,
      minor: 0,
      build: 19044,
      isServer: false,
    ),
    DwmPlatformVersion(
      name: 'Windows Server 2022 Version 21H2',
      major: 10,
      minor: 0,
      build: 20348,
      isServer: true,
    ),
    DwmPlatformVersion(
      name: 'Windows 11 Version 21H2',
      major: 10,
      minor: 0,
      build: 22000,
      isServer: false,
    ),
  ];

  /// The size of this data structure, in bytes. Set this member to sizeof(OSVERSIONINFO).
  final int major;

  /// The minor version number of the operating system. For more information, see Remarks.
  final int minor;

  final int build;

  /// The build number of the operating system.
  final int? platformId;

  final bool? _isServer;

  final String? _name;

  const DwmPlatformVersion({
    required this.major,
    required this.minor,
    required this.build,
    this.platformId,
    bool? isServer,
    String? name,
  })  : _isServer = isServer,
        _name = name;

  String? get name {
    final index =
        versions.indexWhere((v) => v.major == major && v.minor == minor && v.build == build && v.isServer == isServer);
    return index != -1 ? versions[index]._name : '';
  }

  bool? get isServer {
    return _isServer;
  }

  bool get isWindows7 {
    return major == 6 && minor == 1 && build == 7600;
  }

  bool get isWindows7SP1 {
    return major == 6 && minor == 1 && build == 7601;
  }

  bool get isWindows8 {
    return major == 6 && minor == 2 && build == 9200;
  }

  bool get isWindows8Point1 {
    return major == 6 && minor == 3 && (build >= 9200 && build <= 9600);
  }

  bool get isWindows10 {
    return major == 10 && minor == 0 && (build >= 10240 && build <= 20348);
  }

  bool get isWindows11 {
    return major == 10 && minor == 0 && build >= 22000;
  }
}
