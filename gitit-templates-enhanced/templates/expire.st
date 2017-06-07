$if(usecache)$
<script type="text/javascript" src="$base$/js/modules/mousetrap-1.6.1.min.js"></script>
<script type="text/javascript">
   Mousetrap.bind('ctrl+r', function(e) {
     \$.post("$base$/_expire$pageUrl$");
     return true;
   });
</script>
$endif$
