var _pdamoc$elm_borg$Native_CssHelper = function()
{
var current_style_id = null

function log(tag, value)
{
    var msg = tag + ': ' + _elm_lang$core$Native_Utils.toString(value);
    var process = process || {};
    if (process.stdout)
    {
        process.stdout.write(msg);
    }
    else
    {
        console.log(msg);
    }
    return value;
}

function createStyleElement(id, css){
    var style =document.createElement('style');
    style.type='text/css';
    style.id=id;
    style.innerHTML = css;
    document.getElementsByTagName('head')[0].appendChild(style);  
    document.getElementById("elmcss1").disabled = true;
}

function withStyle( css, node)
{
    logRaw(node)
    var elmcss1 = document.getElementById("elmcss1")
    if (current_style_id === null) { 
        createStyleElement("elmcss1", css);
        createStyleElement("elmcss2", "");
        document.getElementById("elmcss1").disabled = false;
        current_style_id = "elmcss1";
        return node;

    } else {
        var current_content = document.getElementById(current_style_id).innerHTML;
        if ( current_content==css) {
            return node;
        } else {
            if (current_style_id == "elmcss1") {
                document.getElementById("elmcss2").innerHTML = css;
                document.getElementById("elmcss2").disabled = false;
                document.getElementById("elmcss1").disabled = true;
                current_style_id = "elmcss2";
                return node;
            } else {

                document.getElementById("elmcss1").innerHTML = css;
                document.getElementById("elmcss1").disabled = false;
                document.getElementById("elmcss2").disabled = true;
                current_style_id = "elmcss1";
                return node;
            }
        }

    }
}

function withMedia(node, css)
{
    logRaw(node);
    return node;
}

function logRaw(value)
{
    var msg = JSON.stringify(value);
    var process = process || {};
    if (process.stdout)
    {
        process.stdout.write(msg);
    }
    else
    {
        console.log(msg);
    }
    return value;
}





return {
    withMedia: F2(withStyle),
    withStyle: F2(withStyle),
    log: F2(log),
    logRaw: logRaw

};

}();