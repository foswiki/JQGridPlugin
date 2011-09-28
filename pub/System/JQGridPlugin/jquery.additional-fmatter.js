jQuery(function($) {
  $.fn.fmatter.image = function(cellVal, opts) {
    if(!$.fmatter.isEmpty(cellVal)) {
      var url,
          op = {
            width: 80,
            baseUrl: '',
            params: '',
            urlFormat: '%url%%value%?%params%'
          };

      if(!$.fmatter.isUndefined(opts.colModel.formatoptions)) {
        op = $.extend({}, op, opts.colModel.formatoptions);
      }

      url = op.urlFormat.
        replace(/%url%/g, op.baseUrl).
        replace(/%value%/g, cellVal).
        replace(/%params%/g, op.params);

      return '<img src="' + url + '" width="'+op.width+'" />';

    } else {
      return $.fn.fmatter.defaultFormat(cellVal, opts);
    }
  };
  $.fn.fmatter.topic = function(cellVal, opts) {
    var op = {
      addParam: opts.addParam || "", 
      target: opts.target
    }, 
    target = "", 
    url, 
    topic = opts.rowId.replace(/\./, '/'),
    viewUrl = foswiki.getPreference("SCRIPTURLPATH")+'/view';

    if(!$.fmatter.isUndefined(opts.colModel.formatoptions)) {
      op = $.extend({},op,opts.colModel.formatoptions);
    }
    if(op.target) {
      target = 'target=' + op.target;
    }

    url = viewUrl+'/'+topic;
    if (op.addParam) {
      url += '?'+ op.addParam;
    }

    if($.fmatter.isString(cellVal)) { //add this one even if its blank string
      return "<a "+target+" href='" + url + "'>" + cellVal + "</a>";
    } else {
      return $.fn.fmatter.defaultFormat(cellVal,opts);
    }
  };
  /* requires jquery.tmpl from http://api.jquery.com/tmpl */
  $.fn.fmatter.tmpl = function(cellVal, opts, rowData) {
    var data = $.extend({
          id: opts.rowId,
          value: cellVal
        }, opts.colModel.formatoptions),
        $rowData = $(rowData);

    $rowData.find("cell").each(function() {
      var $this = $(this), 
          key = $this.attr("name"),
          val = $this.text();

      data[key] = val;
    });

    if($.fmatter.isUndefined(data.template)) {
      return $.fn.fmatter.defaultFormat(cellVal, opts);
    }

    return $("#"+data.template).tmpl(data)
      .appendTo("<div />").parent()[0].innerHTML;
  };
  $.fn.fmatter.tmpl.unformat = function(cellText, opts, cellElem) {
    return $(cellElem).find(".cellValue:first")[0].innerHTML;
  };
});
