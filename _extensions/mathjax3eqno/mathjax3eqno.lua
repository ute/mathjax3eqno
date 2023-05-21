-- displaymath inside span to Rawinlinetex
local pout = quarto.log.output
local str = pandoc.utils.stringify

--pout("hallo?")
--return{{


-- transform dollarmath into proper equations
function Para (el)
  --pout("Para: ") --.. str(el.id))
  --pout(el.t)
  local elco = el.content
  if elco then -- pout(str(el.content)) 
    if type(elco)=="table" then
      for i, v in pairs(elco) do
        if v.t == "Math" and v.mathtype == "DisplayMath" and v.text then 
          --pout(str(i)..": ".. str(v.t).." : "..str(v.text))
          local nxt = elco[i+1]
          if nxt and nxt.t == "Str" then
              a, b = string.find(str(nxt), '{#eq-.*}')
              if a == 1 then 
                local labello = string.sub(str(nxt), 3, b-1) 
           --   pout("danach: "..nxt.t.." : "..labello)
              mathstr = "\\begin{equation}\\label{"..labello.."}"..str(v.text).."\\end{equation}"
              --pout(mathstr)
              end
              -- remove 2 elements and replace with one Rawinlinetex
              newstuff = pandoc.RawInline("tex", mathstr)
              elco[i] = newstuff
              table.remove(elco, i+1)
          end  
        end
      end  
    --  pout("tabelle") end
    else pout("----nixdrin---") end
  --pout(str(el.content))
  end
  return(el)
end

-- secure mathjax rendering. 
-- Not sure if this has to come before quarto?
-- and after all, mathjax is default and this is only a proof of concept
--[[ ]]
function Meta(m)
  if quarto.doc.is_format("html")
  then 
    if m.format then if m.format.html then if m.format.html["html-math-method"] then
      if m.format.html["html-math-method"] ~= "mathjax"
      then pout("!!! overriding html-math-method !!!") end
    end   
    m.format.html["html-math-method"] = "mathjax"
  end
end end end
--]]


function Pandoc(doc)
  local newblocks ={}
  local firstheader = true
  -- insert javascript / latex definitions
  if quarto.doc.is_format("html")
  then 
    quarto.doc.add_html_dependency({
      name = 'mathjax3tags',
      scripts = {'assets/mathjax3.js'}
    })
  elseif quarto.doc.is_format("pdf")
    then 
      quarto.doc.include_file("in-header", 'assets/mathjax3-preamble.tex')
  end 
  
  -- walk headers if in html: add div that call to mathjax 
  -- to increase section counters.
  if doc.blocks then
    for i, blk in ipairs(doc.blocks) do
      if blk.t=="Header" then
        table.insert(newblocks, blk)
        if quarto.doc.is_format("html") and not firstheader then
          local incdiv = pandoc.RawInline("html", 
            '<div style="display:none"><span class="math inline">\\(\\nextSection\\)</span></div>')
          table.insert(newblocks, incdiv)
        end
        firstheader = false
      else  
        table.insert(newblocks, blk)
      end  
    end  
  end
  return pandoc.Pandoc(newblocks, doc.meta)
end