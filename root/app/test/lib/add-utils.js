$.fn.outerHTML = function () {
    var $t = $(this);
    if ('outerHTML' in $t[0]) {
        return $t[0].outerHTML;
    } else {
        var content = $t.wrap('<div></div>').parent().html();
        $t.unwrap();
        return content;
    }
};

String.prototype.strip = function () {
    if (String.prototype.trim) {
        return this.trim();
    }
    else {
        return this.replace(/^\s+|\s+$/g, "");
    }
};
