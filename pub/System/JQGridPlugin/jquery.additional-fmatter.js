jQuery(function($) {
  $.fn.fmatter.image = function(cellVal, opts, rowData) {
    if(!isEmpty(cellVal)) {
      var op = {
        width: 80,
        baseUrl: '',
        params: '',
        urlFormat: '%url%/%value%?%params%'
      };
      if(!isUndefined(opts.colModel.formatoptions)) {
        op = $.extend({}, op, opts.colModel.formatoptions);
      }
      var url = urlFormat.
        replace(/%url%/g, op.baseUrl).
        replace(/%value%/g, cellVal).
        replace(/%params%/g, op.params);

      return '<img src="' + url + '" width="'+op.width+'" />';

    } else {
      return $.fn.fmatter.defaultFormat(cellVal, opts);
    }
  };
  $.fn.fmatter.topic = function(cellVal, opts, rowData) {
    var op = {
      addParam: opts.addParam || "", 
      target: opts.target
    }, 
    target = "", 
    url, 
    topic = opts.rowId.replace(/\./, '/'),
    viewUrl = foswiki.getPreference("SCRIPTURLPATH")+'/view';

    if(!isUndefined(opts.colModel.formatoptions)) {
      op = $.extend({},op,opts.colModel.formatoptions);
    }
    if(op.target) {
      target = 'target=' + op.target;
    }

    url = viewUrl+'/'+topic;
    if (op.addParam) {
      url += '?'+ op.addParam;
    }

    if(isString(cellVal)) { //add this one even if its blank string
      return "<a "+target+" href='" + url + "'>" + cellVal + "</a>";
    } else {
      return $.fn.fmatter.defaultFormat(cellVal,opts);
    }
  };
});
