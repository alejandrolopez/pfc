module ApplicationHelper

  # Enlace para ordenar por el campo (se le pasa la columna de la base de datos) y el titulo a mostrar
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

  # Muestra un texto con el formato de error
  def format_error(params)
    if params.blank?
      return ""
    else
      html_inicial = %( <div id="flash_error">
                          <div class="flash_error_interno">
                            <div class="boton_cerrar">
                              <a title="#{t("close_error")}" class="close_error">X</a>
                            </div> )
      html_final = %(     </div>
                        </div> )

      # Si recibe un string o si recibe un array
      if params.class.to_s.downcase == "string"
        html_medio = "<li>#{params}</li>"

      elsif params.class.to_s.downcase == "array"
        html_medio = ""
        params.each{|a|  html_medio += "<li>" + a + "</li>"}
      end

      return html_inicial + html_medio + html_final
    end
  end

  # Muestra texto en formato notice
  def format_notice(params)
    if params.blank?
      return ""
    else
      html_inicial = %( <div id="flash_notice">
                          <div class="flash_notice_interno">
                            <div class="boton_cerrar">
                              <a title="#{t("close_info")}" class="close_info">X</a>
                            </div> )
      html_final = %(     </div>
                        </div> )

      # Si recibe un string o si recibe un array
      if params.class.to_s.downcase == "string"
        html_medio = "<p>#{params}</p>"

      elsif params.class.to_s.downcase == "array"
        html_medio = ""
        params.each{|a|  html_medio += "<li>" + a + "</li>"}
      end

      return html_inicial + html_medio + html_final
    end
  end

end
