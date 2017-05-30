<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8" />
  <title>$pagetitle$ - $wikititle$</title>
  <link rel="stylesheet" href="$base$/css/bootstrap.min.css" />
  <link rel="stylesheet" href="$base$/css/bootstrap-markdown-editor.css" />
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
  <script src="$base$/js/gitit.min.js"></script>
  <script src="$base$/js/ace-1.2.5/ace.js"></script>
  <script src="$base$/js/bootstrap-markdown-editor.js"></script>
  <!-- editor -->
  <script>
    // Change the textarea into an advanced edtior
    \$('textarea[id="editedText"]').markdownEditor({
      preview: true,
      onPreview: function (content, callback) {
        \$.ajax({
          url: location.pathname.replace(/_edit\\//,"_preview/"),
          type: 'POST',
          dataType: 'html',
          data: {raw: content},
        }).done(function(result) {
          callback(result);
          var e = document.getElementById("MathExample");
          MathJax.Hub.Queue(["Typeset", MathJax.Hub, e])
        });
      }
    });
    // NOTE: This is very important to stop MathJax from changing the formulas
    // in the editor to images. I get the class of the editor from Firefox's
    // inspector. This shall appear AFTER the editor is created.
    \$('.ace_editor').addClass('tex2jax_ignore');
  </script>

  <!-- Bootstrap Modal dialog for page creation -->
  <div class="modal fade" tabindex="-1" role="dialog" id="page_create_dlg">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title">Create a Page</h4>
        </div>
        <div class="modal-body">
          <form>
            <div class="form-group">
              <label>Page Title:</label>
              <input type="text" class="form-control" id="new_page_title" aria-describedby="titleHelp" placeholder="Enter Page Title">
              <small id="titleHelp" class="form-text text-muted">
                Input any string, use '/' to create page in subfolders, for example
                'My Topic/My Thing'.
              </small>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
          <button type="button" class="btn btn-primary" id="page_create_dlg_do">Create Page</button>
        </div>
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div><!-- /.modal -->

  <script>
    \$('#page_create_dlg_do').click(function(){
      var v = \$('#new_page_title').val().trim();
      if (v) {
        \$('#new_page_title').val('');
        var p = "/_edit/" + v;
        location.pathname = p;
      }
    });

    \$("#page_create_link").click(function(){
      \$("#page_create_dlg").modal();
    });
  </script>

</body>

</html>
