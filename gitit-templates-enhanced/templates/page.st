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
  <style>
    .scrollable-menu {
      height: auto;
      max-height: 10em;
      overflow-x: hidden;
    }

    #exportbox {
      display: none;
    }

    .img-responsive {
      max-width: 80%;
      height: auto;
      display: block;
    }

  </style>

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

  $expire()$

  <script src="$base$/js/modules/jquery-3.2.1.min.js"></script>
  <script src="$base$/js/modules/jquery-ui-interactions-1.12.1.min.js"></script>
  <script src="$base$/js/modules/bootstrap-3.3.7.min.js"></script>
  <script src="$base$/js/modules/ace-1.2.5/ace.js"></script>
  <script src="$base$/js/modules/bootstrap-markdown-editor-2.0.2.min.js"></script>
  <script src="$base$/js/modules/gitit.js"></script>
  <script src="$base$/js/modules/mathjax-2.7.1/MathJax.js?config=TeX-AMS_HTML-full" async></script>

  <!-- login status -->
  <script>
    \$.get("/_user", {}, function(username, status) {
      \$(".logged_in_user").text(username);
      if (username == "") {  // nobody logged in
        \$(".registerlink").show();
        \$(".loginlink").show();
        \$(".logoutlink").hide();
      } else {
        \$(".registerlink").hide();
        \$(".loginlink").hide();
        \$(".logoutlink").show();
      };
    });
  </script>

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
    // Added automatic log message
    \$(document).ready(function(){
      var logMsg = \$('#editform #logMsg');
      if (logMsg.length) {
        console.log(logMsg);
        var v = decodeURI(location.pathname.replace(/.*_edit\\//, ""));
        var isCreate = \$('textarea[id="editedText"]').val() ? false : true;
        var msg = `\${isCreate ? "Create" : "Update"} page '\${v}'`;
        logMsg.val(msg);
      }
    });
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
              <div class="input-group">
                <input type="text" class="form-control" id="new_page_title" aria-describedby="titleHelp" placeholder="Enter Page Title">
                <span class="input-group-addon">
                  <input type="checkbox" name="relative" id="relative" />
                  <span>Relative to current page</span>
                </span>
              </div>
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
      \$("#page_create_dlg").modal('hide');
      var v = \$('#new_page_title').val().trim().replace(/^\\//, '');
      if (v) {
        \$('#new_page_title').val('');
        if (\$('#relative').prop('checked') && location.pathname != '/') {
          var r = /.*?(\\/_\\w+)?(\\/[^\\/]+)?(\\/[^\\/]+)\$/;
          var d = decodeURI(location.pathname.replace(r, '\$2'));
          if (d) v = d.substr(1) + "/" + v;
        }
        var p = "/_edit/" + v;
        location.pathname = p;
      }
    });

    \$("#page_create_link").click(function(){
      \$('#page_create_dlg #relative').prop('checked', true);
      \$('#page_create_dlg #new_page_title').val('');
      \$("#page_create_dlg").modal('show');
    });
  </script>

  <!-- Bootstrap Modal dialog for file upload -->
  <div class="modal fade" tabindex="-1" role="dialog" id="file_upload_dlg">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title">Upload a File</h4>
        </div>
        <div class="modal-body">
          <form id="file_upload_form" enctype="multipart/form-data">
            <div class="form-group">
              <label>File to upload:</label>
              <input type="file" name="file" id="file" />
            </div>
            <div class="form-group">
              <label>Name on wiki (including extensions):</label>
              <div class="input-group">
                <input type="text" class="form-control" name="wikiname" id="wikiname" value="" />
                <span class="input-group-addon">
                  <input type="checkbox" name="overwrite" id="overwrite" value="yes"/>
                  <span>Overwrite existing file</span>
                </span>
              </div>
            </div>
            <div class="form-group">
              <label>Commit message:</label>
              <input type="text" class="form-control" name="logMsg" id="logMsg" placeholder="Commit message"/>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
          <button type="button" class="btn btn-primary" id="file_upload_dlg_do">Upload File</button>
        </div>
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div><!-- /.modal -->

  <div class="modal fade" tabindex="-1" role="dialog" id="upload_status_dlg">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
          <h4 class="modal-title" id="upload_status_dlg_title">Title</h4>
        </div>
        <div class="modal-body">
          <span id="upload_status_dlg_content"></span>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
        </div>
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div><!-- /.modal -->

  <script>

    function reset_file_upload_dlg() {
      \$('#file_upload_dlg #file').val('');
      \$('#file_upload_dlg #wikiname').val('');
      \$('#file_upload_dlg #logMsg').val('');
      \$('#file_upload_dlg #overwrite').prop('checked', false);
    }

    \$('#file_upload_dlg #file').change(function(){
        var fn = \$(this).val().split(/[\\\\/]/).pop();
        \$('#file_upload_dlg #wikiname').val(fn);
        \$('#file_upload_dlg #logMsg').val(`Upload file '\${fn}'`);
    });

    \$('#file_upload_dlg_do').click(function(){
      var v = \$('#file').val();
      if (v) {
        \$.ajax({
          type: 'POST',
          url: '/_upload',
          cache: false,
          data: new FormData(\$('#file_upload_form')[0]),
          processData: false,
          contentType: false
        }).done(function(res){
          \$('#file_upload_dlg').modal('hide');
          var doc = document.implementation.createHTMLDocument("TMP");
          var dom = jQuery.parseHTML(res, doc, false);
          var obj = jQuery(dom).find("#main #content");
          var title = jQuery(obj).find(".pageTitle");
          \$('#upload_status_dlg_title').text(title.text());
          var msg = jQuery(obj).find(".messages");
          if (msg.length) {
            // Upload failed due to server limits, show the diag message
            \$('#upload_status_dlg_content').html(msg);
          } else {
            // Upload succeed, show the returned messages. 
            \$('#upload_status_dlg_content').html(obj);
          }
          \$('#upload_status_dlg').modal('show');
        }).fail(function(req){
          // Gitit always return success even if the upload acutally failed.
          // the fail status only occurs when the ajax acutally failed.
          \$('#file_upload_dlg').modal('hide');
          \$('#upload_status_dlg_title').text('Upload Failed');
          \$('#upload_status_dlg_content').html(req.responseText);
          \$('#upload_status_dlg').modal('show');
        });
      }
    });

    \$("#file_upload_link").click(function(){
      reset_file_upload_dlg();
      \$("#file_upload_dlg").modal('show');
    });
  </script>

  <script>
    // NOTE: hide it directly in css to avoid users seeing it.
    // \$('#exportbox').hide();
    var dropdown = \$('<div/>', {'class': 'dropup'});
    \$('<a/>', {
      'role': "button",
      'class': "dropdown-toggle",
      'data-toggle': "dropdown",
      'aria-haspopup': "true",
      'aria-expanded': "false",
      'href': "javascript:void(0)"
    }).html(' Export page as ')
      .prepend(\$('<span/>', {'class': 'glyphicon glyphicon-export', 'aria-hidden': "true"}))
      .append(\$('<span/>', {'class': "caret"}))
      .appendTo(dropdown);
    var ul = \$('<ul>', {'class': 'dropdown-menu scrollable-menu'});
    \$('#exportbox select > option').each(function() {
      var link = \$('<a/>', {href: 'javascript:void(0)', 'class': 'dropdown-item'})
        .html(\$(this).text())
        .click(function() {
          \$('#exportbox select').val(\$(this).text());
          // NOTE: trigger the form submit event does not work, so simulate it
          // by triggering click on the export button.
          \$('#export').trigger('click');
        });
      \$("<li/>").append(link).appendTo(ul);
    });
    ul.appendTo(dropdown);
    \$('#exportbox').before(dropdown);
  </script>
  <script>
    // Make the document more bootstrap
    \$('table').addClass('table table-bordered table-striped');
    \$('div.figure p').addClass('text-center');
    \$('div.figure img').addClass('img-responsive center-block image-rounded');
  </script>

</body>

</html>
