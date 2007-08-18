class ViewableMimeType
  VIEWABLE_FILE_EXTENSIONS = {
    # browser viewable images
    'png'   => 'image/png',
    'jpg'   => 'image/jpg', 
    'jpeg' => 'image/jpeg',
    'gif'   => 'image/gif',
    # Source/texty files 
    'txt'   => 'text/plain',
    'html'  => 'text/html',
    'css'   => 'text/css',
    'xml'   => 'text/xml',
    'xsl'   => 'text/xsl',
    'js'    => 'text/javascript',
    'rb'    => 'text/x-ruby',
    'rhtml' => 'text/x-html+ruby',
    'rxml'  => 'text/x-ruby',
    'yml'   => 'text/x-yaml',
    'yaml'  => 'text/x-yaml',
    'htaccess' => 'text/plain',
    'c'     => 'text/x-c-source',
    'cpp'   => 'text/x-cc-source',
    'cc'    => 'text/x-cc-source',
    'h'     => 'text/x-c-header',
    'hh'    => 'text/x-cc-header',
    'hpp'   => 'text/x-cc-header',
    'm'     => 'text/x-objc',
    'hs'    => 'text/x-hashell',
    'ini'   => 'text/plain', # ?
    'pl'    => 'text/x-perl',
    'pm'    => 'text/x-perl',
    'php'   => 'text/x-httpd-php', # ?
    'php3'  => 'text/x-httpd-php', # ?
    'php4'  => 'text/x-httpd-php', # ?
    'php5'  => 'text/x-httpd-php', # ?
    'py'    => 'text/x-python',
    'sh'    => 'text/x-sh',
    'sql'   => 'text/x-sql',
    'tex'   => 'text/x-tex',
    'asp'   => 'text/x-asp', # ?
    'java'  => 'text/x-java',
    'cgi'   => 'text/x-cgi', # ?
    'fcgi'  => 'text/x-cgi', # ?
    'as'    => 'text/x-actionscript' # ?
  }
  
  def self.find_by_extension(ext)
    ext.gsub!(/^./, '')
    VIEWABLE_FILE_EXTENSIONS[ext] || nil
  end
end