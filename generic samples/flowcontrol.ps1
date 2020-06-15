#region switch

# using switch to count
$archiveextensions = '.7z','.7zip','.ace','.air','.apk','.appxbundle','.arc','.arj','.asec','.bar','.bin','.cab','.cso','.deb','.dlc','.gz','.gzip','.hqx','.inv','.ipa','.isz','.jar',,'.msu','.nbh','.pak','.rar','.rpm','.sis','.sisx','.sit','.sitd','.sitx','.tar','.tar.gz','.tgz','.webarchive','.xap','.zip'
$audioextensions = '.3ga','.aac','.aiff','.amr','.ape','.arf','.asf','.cda','.dvf','.flac','.logic','.m4a','.m4b','.m4p','.midi','.mp3','.ogg','.pcm','.rec','.snd','.sng','.uax','.wav','.wma','.wpl','.zab'
$documentextensions = '.1st','.abw','.accdb','.accdt','.alx','.application','.asp','.aww','.azw','.azw3','.azw4','.cbr','.cbz','.chm','.cnt','.csv','.doc','.docm','.docx','.dot','.dotm','.dotx','.eng','.epub','.fb2','.htm','.html','.iba','.ibooks','.ind','.indd','.key','.keynote','.lit','.log','.lrc','.lst','.mdb','.mht','.mobi','.mpd','.mpp','.mpt','.nfo','.numbers','.odf','.ods','.odt','.oft','.one','.onepkg','.onetoc2','.opml','.ott','.oxps','.pages','.pdf','.plist','.pmd','.pot','.potx','.pps','.ppsx','.ppt','.pptm','.pptx','.prn','.ps','.pub','.pwi','.reg','.rep','.rtf','.sdc','.sdd','.sdw','.shs','.snp','.srt','.sub','.sxc','.sxw','.tbl','.text','.thmx','.tpl','.txt','.vsd','.vsdx','.wlmp','.wpd','.wps','.wri','.xls','.xlsm','.xlsx','.xlsb','.xml','.xps','.xsd','.xsl','.xslt'
$graphicsextensions = '.3d','.3ds','.abr','.ai','.ani'.'.arw','.bmp'.'.c4d','.cdr','.cdt','.cpt','.cr2','.crw','.csh','.dcr','.dds','.dgn','.dib','.djvu','.dng','.drw','.dt2','.dwfx','.dwg','.dxf','.emf','.emz','.eps','.fla','.fpx','.gif','.icns','.ico','.icon','.jpeg','.jpg','.lcf','.max','.mdi','.mrw','.nef','.odg','.orf','.pcd','.pcx','.pic','.png','.pro','.psb','.psd','.psdx','.pts','.ptx','.pzl','.raf','.raw','.rw2','.sda','.skp','.stl','.sup','.svg','.tga','.thm','.tif','.tiff','.u3d','.wbmp','.wdp','.webp','.wmf','.x_t'
$mailextensions = '.dbx','.eml','.ldif','.msg','.pst','.vcf'
$videoextensions = '.264','.3g2','.3gp','.asx','.avi','.bik','.dash','.dat','.dvr','.flv','.h264','.m2t','.m2ts','.m4v','.mkv','.mod','.mov','.mp4','.mpeg','.mpg','.mswmm','.mts','.ogv','.prproj','.rmvb','.swf','.tod','.tp','.ts','.vob','.webm','.wmv'

$files = Get-ChildItem -Path $env:OneDriveCommercial -Recurse -Force -ErrorAction SilentlyContinue
switch ($files)
    {
        { $archiveextensions -contains $_.Extension } { $ArchiveSize += $_.Length }
        { $audioextensions -contains $_.Extension } { $AudioSize += $_.Length }
        { $documentextensions -contains $_.Extension } { $DocumentSize += $_.Length }
        { $graphicsextensions -contains $_.Extension } { $GraphicsSize += $_.Length }
        { $mailextensions -contains $_.Extension } { $MailSize += $_.Length }
        { $videoextensions -contains $_.Extension } { $VideoSize += $_.Length }
        default { $OtherSize += $_.Length }
    }
# switch wildcard

switch -Wildcard ("fourteen")
       {
           1 {"It is one."; Break}
           2 {"It is two."; Break}
           3 {"It is three."; Break}
           4 {"It is four."; Break}
           "fo*" {"That's too many."}
       }

# switch file looks at each line in a file

# swtch regex
$target = 'user1@contoso.com'
switch -Regex ($target)
{
    'ftp\://.*' { "$_ is an ftp address"; Break }
    '\w+@\w+\.com|edu|org' { "$_ is an email address"; Break }
    'http[s]?\://.*' { "$_ is a web address"; Break }
}
#endregion