# frozen_string_literal: true
#
module ApplicationHelper

  # @param [String] url source of remote page
  # @return [String] write a content tag for load a remote page
  def loader(url)
    # "<div data-target='page.loader', url='#{url}'>Sto caricando</div>".html_safe
    content_tag(:div, 'Sto caricando', url: url, data: { target: 'page.loader' })
  end

  # make a div for the font-awesome icons
  def fas_icon(fa_style, span_style: nil, style: false, text: '', html: '', tooltip: false)
    content_tag_i = tag.i('', class: "fas fa-#{fa_style}", aria: { hidden: 'true' })
    span = if tooltip.present?
             tag.span(content_tag_i, class: "icon #{span_style}", style: style, data: { tooltip: tooltip })
           else
             tag.span(content_tag_i, class: "icon #{span_style}", style: style)
           end
    return span if text.blank? && html.blank?

    span + tag.span(text) + tag.span(html.html_safe)
  end

  # map of flash and rub notify() for each flash
  def notifications
    flash.map { |type, text| notify(text, type: type) }.join
  end

  # map of status and run notify() for each status
  # @param [Hash] status
  def notify_status(status = {})
    status.map { |k, v| notify(v, type: k) }.join
  end

  # @param text [String] text of notification
  # @param type [String] type of notification, default: 'alert'
  # @param timeout [String] set the timeout for javascript action, default: 3000
  # @param hidden [Boolean] set visibility class, default true
  # @return [String] Make a div with for the notification
  def notify(text, type: 'alert', timeout: 3000, hidden: true)
    content_tag(:div, text.to_s, class: "notification is-#{type} #{'is-hidden' if hidden}", data: { controller: 'noty', noty_type: type, noty_timeout: timeout })
  end

  # generate a list for a select from an enum
  # @param list [Hash], enum option list, default {}
  # @param scope [String] scope of localization, default ''
  # @return [List]
  def t_enum(list = {}, scope = '')
    list.map { |k, _| [t(k, scope: scope), k] }
  end

  # Localize a DateTime with format :long if #obj is present
  # @param [DateTime] obj
  # @return [String] localized and formatted date
  def l_long(obj = nil)
    l(obj, format: :long) if obj.present?
  end

  # Localize a DateTime with format :time if #obj is present
  # @param [DateTime] obj
  # @return [String] localized and formatted date
  def l_time(obj = nil)
    l(obj, format: :time) if obj.present?
  end

  # Localize a DateTime with format :date if #obj is present
  # @param [DateTime,Date] obj
  # @return [String] localized and formatted date
  def l_date(obj = nil)
    l(obj.try(:to_date), format: :date) if obj.present?
  end

  # Localize a fieldName if #obj is present
  # @param [Text] field_label
  # @param [Text] obj
  # @return [String] localized
  def t_field(field_label = nil, obj = '')
    return '' if field_label.blank?

    case obj
    when Class
      t(field_label, scope: "activerecord.attributes.#{obj.class}")
    when String
      t(field_label, scope: "activerecord.attributes.#{obj}")
    else
      t(field_label, default: field_label)
    end
  end
end
