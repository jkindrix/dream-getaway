(function () { 
    function e(e, n, i) { 
        document.addEventListener(e, function (e) { 
            if (!e.defaultPrevented) 
                for (var t = e.target; t && t != this; t = t.parentNode)
                    if (t.matches(n)) { 
                        !1 === i.call(t, e) && (e.preventDefault(), e.stopPropagation()); 
                        break 
                    } 
        }, !1) 
    } 
    
    var t = document.body.parentElement, i = [], r = null, o = document.body.classList.contains("typora-export-collapse-outline"); 
    
    function a() { 
        return t.scrollTop 
    } 
    
    e("click", ".outline-expander", function (e) { 
        var t = this.closest(".outline-item-wrapper").classList; 
        return t.contains("outline-item-open") ? t.remove("outline-item-open") : t.add("outline-item-open"), u(), !1 
    }), 
    
    e("click", ".outline-item", function (e) { 
        var t = this.querySelector(".outline-label"); 
        location.hash = "#" + t.getAttribute("href"), 
        o && ((t = this.closest(".outline-item-wrapper").classList).contains("outline-item-open") || t.add("outline-item-open"), d(), t.add("outline-item-active")) 
    }); 
    
    function s() { 
        var e = a(); 
        r = null; 
        for (var t = 0; t < i.length && i[t][1] - e < 60; t++)
            r = i[t] 
    } 
    
    function n() { 
        c = setTimeout(function () { 
            var n; i = [], n = a(), 
            document.querySelector("#write").querySelectorAll("h1, h2, h3, h4, h5, h6").forEach(e => { 
                var t = e.getAttribute("id"); 
                i.push([t, n + e.getBoundingClientRect().y]) 
            }), 
            s(), u() 
        }, 300) 
    } 
    
    var l, c, d = function () { 
        document.querySelectorAll(".outline-item-active").forEach(e => e.classList.remove("outline-item-active")), 
        document.querySelectorAll(".outline-item-single.outline-item-open").forEach(e => e.classList.remove("outline-item-open")) 
    }, 
    
    u = function () { 
        if (r && (d(), t = document.querySelector('.outline-label[href="#' + (CSS.escape ? CSS.escape(r[0]) : r[0]) + '"]'))) 
            if (o) { 
                var e = t.closest(".outline-item-open>ul>.outline-item-wrapper"); 
                if (e) e.classList.add("outline-item-active"); 
                else { 
                    for (var t, n = (t = t.closest(".outline-item-wrapper")).parentElement.closest(".outline-item-wrapper"); n;)
                        n = (t = n).parentElement.closest(".outline-item-wrapper"); 
                    t.classList.add("outline-item-active") 
                } 
            } else t.closest(".outline-item-wrapper").classList.add("outline-item-active") 
    }; 
    
    window.addEventListener("scroll", function (e) { 
        l && clearTimeout(l), l = setTimeout(function () { 
            s(), u() 
        }, 300) 
    }); 
    
    window.addEventListener("resize", function (e) { 
        c && clearTimeout(c), n() 
    }), n() 
})();