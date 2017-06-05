
<div class="hidden-xs hidden-sm col-md-12">
    $logo()$
</div>

<div class="col-md-12">
  <form action="$base$/_search" method="get" id="searchform">
    <div class="input-group">
      <input type="text" name="patterns" id="patterns"
      class="form-control" placeholder="Search" />
      <div class="input-group-addon">
        <span class="glyphicon glyphicon-search"></span>
      </div>
    </div>
  </form>
</div>

<div class="col-sm-6 col-md-12">
    <div class="panel panel-default">
        <div class="panel-heading">Site</div>
        <div class="panel-body">
            <ul>
                <li><a href="$base$/">
                    <span class="glyphicon glyphicon-home" aria-hidden="true"></span>
                    Front page
                </a></li>
                <li><a href="$base$/_index">
                    <span class="glyphicon glyphicon-book" aria-hidden="true"></span>
                    All pages
                </a></li>
                <li><a href="$base$/_categories">
                    <span class="glyphicon glyphicon-tags" aria-hidden="true"></span>
                    Categories
                </a></li>
                <li><a href="$base$/_random">
                    <span class="glyphicon glyphicon-random" aria-hidden="true"></span>
                    Random page
                </a></li>
                <li><a href="$base$/_activity">
                    <span class="glyphicon glyphicon-film" aria-hidden="true"></span>
                    Recent activity
                </a></li>
                <li><a id="page_create_link" href="javascript:void(0)">
                    <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                    Create a page
                </a></li>
                $if(wikiupload)$
                <!-- <li><a href="$base$/_upload"> -->
                <li><a id="file_upload_link" href="javascript:void(0)">
                    <span class="glyphicon glyphicon-upload" aria-hidden="true"></span>
                    Upload a file
                </a></li>
                $endif$
                $if(feed)$
                <li><a href="$base$/_feed/" type="application/atom+xml" rel="alternate" title="ATOM Feed">
                    <span class="glyphicon glyphicon-list-alt" aria-hidden="true"></span>
                    Atom feed
                </a></li>
                $endif$
                <li><a href="$base$/Help">
                    <span class="glyphicon glyphicon-heart-empty" aria-hidden="true"></span>
                    Help
                </a></li>
            </ul>
        </div>
    </div>
</div>

<div class="col-sm-6 col-md-12">
    <div class="panel panel-default">
        <div class="panel-heading">This page</div>
        <div class="panel-body">
            <ul>
                <li><a href="$base$/_showraw$pageUrl$$if(revision)$?revision=$revision$$endif$">
                    <span class="glyphicon glyphicon-save" aria-hidden="true"></span>
                    Raw page source
                </a></li>
                <li><a href="$base$/_delete$pageUrl$">
                    <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                    Delete this page
                </a></li>
                $if(feed)$
                <li><a href="$base$/_feed$pageUrl$" type="application/atom+xml" rel="alternate" title="This page's ATOM Feed">
                    <span class="glyphicon glyphicon-list-alt" aria-hidden="true"></span>
                    Atom feed
                </a></li>
                $endif$
            </ul>
            $exportbox$
        </div>
    </div>
</div>
