$(document).ready(function() {
  // replace all oembed links with actual content
  $('a.oembed').embedly({maxWidth:400,'method':'replace'});
});