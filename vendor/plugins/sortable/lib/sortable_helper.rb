module SortableHelper
  # Helper method to generate a sortable table in the view
  # 
  # usage: <%= sortable_table(optional_params) %>
  # 
  # optional_params:
  # 
  # :paginate - Whether or not to display pagination links for the table. Default is true.
  # :partial - Name of the partial containing the table to display. Default is the table partial in the sortable
  #            plugin: 'sortable/table'
  #            
  #            If you choose to create your own partial in place of the one distributed with the sortable plugin 
  #            your partial has the following available to it for generating the table:
  #              @headings contains the table heading values
  #              @objects contains the collection of objects to be displayed in the table
  #              
  # :search - Whether or not to include a search field for the table. Default is true.
  # :extra - An array of extra content that is added to each row. e.g. a link that you'd like to appear on each object.
  #          Note: Each entry in the array must be a partial. The partial has access to the row "object" via the
  #                local variable named "object".

  def sortable_table(options={})
    paginate = options[:paginate].nil? ? true : options[:paginate]
    partial = options[:partial].nil? ? 'sortable/table' : options[:partial]  
    search = options[:search].nil? ? true : options[:search]
    extra_cell_content = options[:extra].nil? ? '' : options[:extra]
    filter = options[:filter].nil? ? '' : options[:filter]

    result = render(:partial => partial, :locals => {:search => search, :extra => extra_cell_content, :filter => filter})
    result += will_paginate(@objects).to_s if paginate
    result
  end
 
    
  def sort_td_class_helper(param)
    result = 'sortup' if params[:sort] == param
    result = 'sortdown' if params[:sort] == param + "_reverse"
    result = @sortclass if @default_sort && @default_sort == param    
    return result
  end

  def sort_link_helper(action, text, param, params, is_secondary, extra_params={})
    if @sort_map[param]
      primary_arrow_link = primary_secondary_sort_link(false,'Primary Sort',action, param, params, extra_params)
      if is_secondary
        secondary_arrow_link = primary_secondary_sort_link(true,'Secondary Sort',action, param, params, extra_params)
      end
      return text, primary_arrow_link, secondary_arrow_link
    else
      text
    end
  end

  def primary_secondary_sort_link(is_secondary,title,action,param,params,extra_params)
    icon_sort = is_secondary ? secondary_sort_arrows(param) : primary_sort_arrows(param)
    options = build_url_params(action, param, params, is_secondary, extra_params)
    html_options = {:title => title}
    link_to(icon_sort, options, html_options)
  end

  def primary_sort_arrows(param)
    icon_primary_up = '<span class="icon_sort_up fr mt8" title="Primary Sort"></span>'
    icon_primary_down = '<span class="icon_sort_down fr mt8" title="Primary Sort"></span>'
    icon_primary_up_disabled = '<span class="icon_sort_up_disabled fr mt8" title="Primary Sort"></span>'
    if @default_sort_key && @default_sort.eql?(param)
      icon_primary_down
    else
      if params[:sort].eql?(param)
        params[:dir].eql?('up') ? icon_primary_up : icon_primary_down
      elsif params[:sort].eql?(param + '_reverse')
        icon_primary_down
      else
        icon_primary_up_disabled
      end
    end
  end

  def secondary_sort_arrows(param)
    display_icon = (@default_sort_key && @default_sort.eql?(param)) || (params[:sort].eql?(param)) || (params[:sort].eql?(param + '_reverse')) ? "display:none" : "display:block"
    icon_secondary_up = "<span class='icon_sort_up fr mt8' title='Secondary Sort' style='#{display_icon}'></span>"
    icon_secondary_down = "<span class='icon_sort_down fr mt8' title='Secondary Sort' style='#{display_icon}'></span>"
    icon_secondary_up_disabled = "<span class='icon_sort_up_disabled fr mt8' title='Secondary Sort' style='#{display_icon}'></span>"
    icon_secondary_down_disabled = "<span class='icon_sort_down_disabled fr mt8' title='Secondary Sort' style='#{display_icon}'></span>"
    if params[:secondary_sort].eql?(param)
      icon_secondary = params[:dir].eql?('down') ? icon_secondary_up : icon_secondary_down
    elsif params[:secondary_sort].eql?(param + '_reverse')
      icon_secondary = icon_secondary_down
    else
      icon_secondary = params[:dir].eql?('up') ? icon_secondary_up_disabled : icon_secondary_down_disabled
    end
    return  "</br>"+icon_secondary
  end
  
  def build_url_params(action, param, params, secondary, extra_params={})
    key = param
    if @default_sort_key && @default_sort == param
      key = @default_sort_key
      params[:dir] = "up"
    else
      if params[:sort] == param || params[:secondary_sort] == param
        key += "_reverse"
        params[:dir] = "down"
      else
        params[:dir] = "up"
      end
    end

    extra_params.merge!({:letter => params[:letter]}) if params[:letter]
    if secondary
      params = {:sort => params[:sort],
        :secondary_sort => key,
        :page => nil, # when sorting we start over on page 1
        :q => params[:q],
        :dir => params[:dir]}
    else
      params = {:sort => key,
        :secondary_sort => params[:secondary_sort],
        :page => nil, # when sorting we start over on page 1
        :q => params[:q],
        :dir => params[:dir]
      }
    end
    params.merge!(extra_params)

    return {:action => action, :params => params}
  end

  def row_cell_link(new_location)
    mouseover_pointer + "onclick='window.location=\"#{new_location}\"'"
  end

  def mouseover_pointer
    "onmouseover='this.style.cursor = \"pointer\"' onmouseout='this.style.cursor=\"auto\"'"
  end

  def table_header(prefix_columns="")
    result = "<tr class='tableHeaderRow'>"
    result += prefix_columns
    @headings.each do |heading|
      sort_class = sort_td_class_helper heading[1]
      result += "<td"
      result += " class='#{sort_class}'" if !sort_class.blank?
      result += ">"
      result += sort_link_helper @action, heading[0], heading[1], params, false
      result += " | "
      result += sort_link_helper @action, heading[0], heading[1], params, true
      result += "</td>"
    end
    result += "</tr>"
    return result
  end
   
  # use this helper to build a row for a set of related objects and display them and their properties in a list
  def build_display_relations_sub_row(relations_collection, display_prop)
    result = "<tr><td colspan='10'><ul>"
    relations_collection.each do |t|
      result += "<li> <a href='#' onClick='Element.toggle(\"#{dom_id(t)}view\"); toggle_collapse(this); return false;'
                        class='collapse' >#{t.send(display_prop)}</a>
              <div id='#{dom_id(t)}view' style='display: none;' class='contact_view'>"
      t.attributes.each do |a|
        result +=     "#{a[0]} : #{a[1]}<br/>"
      end
      result +=             "</div>	</li>"
    end
    result += "</ul></td></tr>"
    return result
  end

  def letter_search(param)
    letter_selected = param[:letter]
    result = '<ul class="alphabetical fl">'
    "A".upto("Z") do |alpha|
      result += letter_selected.eql?(alpha) ? '<li class="active">'+link_to(alpha, apply_sort(alpha,param))+'</li>' : '<li>'+link_to(alpha, apply_sort(alpha,param))+'</li>'
    end
    result += '</ul>'
  end

  def apply_sort(alpha,param)
    param.merge!(:letter => alpha)
  end

end
