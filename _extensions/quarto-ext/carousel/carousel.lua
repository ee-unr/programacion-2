function carousel(items, duration, id)
  local id = id or ("carousel-" .. pandoc.utils.sha1(pandoc.utils.stringify(items)))
  local duration = duration or 3000

  local buttons = {}
  local slides = {}

  for i, item in ipairs(items) do
    local active = (i == 1) and " active" or ""
    local aria_current = (i == 1) and ' aria-current="true"' or ""

    -- Indicator button
    table.insert(buttons, string.format(
      '<button type="button" data-bs-target="#%s" data-bs-slide-to="%d" class="%s"%s aria-label="Slide %d"></button>',
      id, i-1, (i==1) and "active" or "", aria_current, i
    ))

    -- Carousel item
    table.insert(slides, string.format(
      [[<div class="carousel-item %s" data-bs-interval="%d">
            <img src="%s" class="d-block mx-auto">
         <div class="carousel-caption d-none d-md-block">
            <p class="fw-light">%s</p>
         </div>
        </div>]],
      active, duration, item.image, item.caption or ""
    ))


    
  end

  return string.format(
    [[<div id="%s" class="carousel carousel-dark slide" data-bs-ride="false">
        <div class="carousel-indicators">%s</div>
        <div class="carousel-inner">%s</div>

        <button class="carousel-control-prev" type="button" data-bs-target="#%s" data-bs-slide="prev">
          <span class="carousel-control-prev-icon" aria-hidden="true"></span>
          <span class="visually-hidden">Previous</span>
        </button>

        <button class="carousel-control-next" type="button" data-bs-target="#%s" data-bs-slide="next">
          <span class="carousel-control-next-icon" aria-hidden="true"></span>
          <span class="visually-hidden">Next</span>
        </button>

      </div>]],
    id, table.concat(buttons, "\n"), table.concat(slides, "\n"), id, id
  )
end

function Div(el)
  if el.classes:includes("carousel") then
    local duration = tonumber(el.attributes["duration"]) or 3000
    local id = el.identifier or "carousel"

    local items = {}
    for _, blk in ipairs(el.content or {}) do
      if blk.t == "Div" and blk.classes:includes("item") then
        -- Explicit .item div
        table.insert(items, {
          caption = pandoc.utils.stringify(blk.attributes.caption or ""),
          image   = blk.attributes.image or "",
        })

      elseif blk.t == "Figure" and blk.content and blk.content[1] and blk.content[1].content then
        -- ![caption](path)
        local img = blk.content[1].content[1]
        if img and img.t == "Image" then
          local caption = pandoc.utils.stringify(blk.caption or "")
          local src = img.src or ""
          table.insert(items, { caption = caption, image = src })
        end

      elseif blk.t == "Para" and blk.content and #blk.content == 1 and blk.content[1].t == "Image" then
        -- ![](path) or ![](path){caption="..."}
        local img = blk.content[1]
        local caption = pandoc.utils.stringify(img.caption or "") or img.attributes["caption"] or ""
        local src = img.src or ""
        table.insert(items, { caption = caption, image = src })
      end
    end

    return pandoc.RawBlock("html", carousel(items, duration, id))
  end
end
