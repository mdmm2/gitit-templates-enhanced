// Drag and drop to compare versions
$(document).ready(function() {
  $("#content h1 :contains('Changes to')").parent().before(
    "<div class='alert alert-info' role='alert'>" +
    "  <span class='glyphicon glyphicon-info-sign' aria-hidden='true'></span>" +
    "  Drag one revision onto another to see differences." +
    "</div>"
  );
  $(".difflink").draggable({
    helper: "clone"
  });
  $(".difflink").droppable({
    accept: ".difflink",
    drop: function(ev, ui) {
      var targetOrder = parseInt($(this).attr("order"));
      var sourceOrder = parseInt($(ui.draggable).attr("order"));
      var diffurl = $(this).attr("diffurl");
      if (targetOrder < sourceOrder) {
        var fromRev = $(this).attr("revision");
        var toRev = $(ui.draggable).attr("revision");
      } else {
        var toRev = $(this).attr("revision");
        var fromRev = $(ui.draggable).attr("revision");
      };
      location.href = diffurl + '?from=' + fromRev + '&to=' + toRev;
    }
  });
});

// Fancy footnotes
var Footnotes = {
  footnotetimeout: false,
  setup: function() {
    var footnotelinks = $('.footnoteRef')

    footnotelinks.unbind('mouseover', Footnotes.footnoteover);
    footnotelinks.unbind('mouseout', Footnotes.footnoteoout);

    footnotelinks.bind('mouseover', Footnotes.footnoteover);
    footnotelinks.bind('mouseout', Footnotes.footnoteoout);
  },
  footnoteover: function() {
    clearTimeout(Footnotes.footnotetimeout);
    $('#footnotediv').stop();
    $('#footnotediv').remove();

    var id = $(this).attr('href').substr(1);
    var position = $(this).offset();

    var div = $(document.createElement('div'));
    div.attr('id', 'footnotediv');
    div.bind('mouseover', Footnotes.divover);
    div.bind('mouseout', Footnotes.footnoteoout);

    var el = document.getElementById(id);
    div.html('<div>' + $(el).html() + '</div>');

    $(document.body).append(div);

    var left = position.left;
    if (left + 420 > $(window).width() + $(window).scrollLeft())
      left = $(window).width() - 420 + $(window).scrollLeft();
    var top = position.top + 20;
    if (top + div.height() > $(window).height() + $(window).scrollTop())
      top = position.top - div.height() - 15;
    div.css({
      left: left,
      top: top,
      opacity: 0.95,
      position: "absolute"
    });
  },
  footnoteoout: function() {
    Footnotes.footnotetimeout = setTimeout(function() {
      $('#footnotediv').animate({
        opacity: 0
      }, 600, function() {
        $('#footnotediv').remove();
      });
    }, 100);
  },
  divover: function() {
    clearTimeout(Footnotes.footnotetimeout);
    $('#footnotediv').stop();
    $('#footnotediv').css({
      opacity: 0.9
    });
  }
}
$(document).ready(function() {
  Footnotes.setup();
});

// Highlight search results
jQuery.fn.highlightPattern = function(patt, className) {
  // check if patt starts or ends with non-word character
  // and set regex boundary accordingly.
  var start = '\\b(';
  var end = ')\\b';
  if (/\W/.test(patt.charAt(0))) {
    var start = '\(?=\\W\)(';
  };
  if (/\W/.test(patt.charAt(patt.length - 1))) {
    var end = ')\(?!\\w\)';
  }
  // escape regex metacharacters that may be in the patt
  var epatt = patt.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1")

  // patt is a space separated list of strings - we want to highlight
  // an occurrence of any of these strings as a separate word.
  var regex = new RegExp(start + epatt.replace(/ /g, '| ') + end, 'gi');

  return this.each(function() {
    this.innerHTML = this.innerHTML.replace(regex,
      '<span class=\'' + className + '\'>' + '$1' + '</span>');
  });
};

function toggleMatches(obj) {
  var pattern = $('#pattern').text();
  var matches = obj.next('.matches')
  matches.slideToggle(300);
  matches.highlightPattern(pattern, 'highlighted');
  if (obj.html() == '[show matches]') {
    obj.html('[hide matches]');
  } else {
    obj.html('[show matches]');
  };
}

// UI tweaks
$(document).ready(function() {
  $('a.showmatch').attr('onClick', 'toggleMatches($(this));');
  $('pre.matches').hide();
  $('a.showmatch').show();
  $("#previewButton").hide(); // previewButton is obsolute
  $("pre.diff").attr('wrap', 'true');
});
