require 'net/http'
require 'uri'

class LogsController < ApplicationController
  def show
    url = URI.parse("http://#{params[:id]}")

    if url.host.in?(Server.all.map{|s| URI(s.uri).host rescue nil}.uniq.compact)
      req = Net::HTTP::Get.new(url.path)
      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end

      render html: res.body.html_safe
    else
      redirect_to root_path
    end
  end
end
