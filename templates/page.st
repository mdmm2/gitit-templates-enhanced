<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8" />
  <title>$pagetitle$ - $wikititle$</title>
  <link rel="stylesheet" href="$base$/css/bootstrap.min.css" />
  <link rel="stylesheet" href="$base$/css/gitit.css" />
  $if(feed)$
  <link href="$base$/_feed/" type="application/atom+xml" rel="alternate" title="Sitewide ATOM Feed" />
  <link href="$base$/_feed$pageUrl$" type="application/atom+xml" rel="alternate" title="This page's ATOM Feed" />
  $endif$
</head>

<body>
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-10 col-md-push-2" id="maincol">
        <div class="hidden-print">
          $userbox()$
          $tabs$
        </div>
        $content()$
        $if(markuphelp)$
          $markuphelp()$
        $endif$
      </div>
      <div class="col-md-2 col-md-pull-10 hidden-print" id="sidebar">
        <div class="row">
          $sidebar()$
        </div>
      </div>
      <div class="col-md-10 col-md-push-2 hidden-print">
        $footer()$
      </div>
    </div>
  </div>
  $javascripts$
  $expire()$
  $getuser()$
  <script src="$base$/js/jquery.min.js"></script>
  <script src="$base$/js/bootstrap.min.js"></script>
  <script src="$base$/js/jquery-ui-1.10.4.custom.min.js"></script>
  <script src="$base$/js/gitit.min.js"></script>
  <script src="$base$/js/ace-1.2.5/ace.js"></script>
  <!-- editor -->
  <script>
    \$('textarea[id="editedText"]').each(function () {
      var textarea = \$(this);
      var editDiv = \$('<div>', {
        position: 'absolute',
        height: textarea.height(),
        'class': "tex2jax_ignore",   // ignore mathjax on the editor
        id: "editedTextAce"
      }).insertBefore(textarea);
      textarea.css('display', 'none');

      var editor = ace.edit(editDiv[0]);
      editor.setTheme("ace/theme/tomorrow");
      editor.setKeyboardHandler();
      editor.renderer.setShowGutter(false);
      editor.getSession().setUseWrapMode(true);
      editor.getSession().setValue(textarea.val());
      editor.getSession().setMode("ace/mode/markdown");

      editor.getSession().on('change', function(){
        textarea.val(editor.getSession().getValue());
      });

    });
  </script>
</body>

</html>
