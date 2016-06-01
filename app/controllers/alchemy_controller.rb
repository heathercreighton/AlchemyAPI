
class AlchemyController < ApplicationController
	



  def index
	end



  def results

  # Calls all previous entries in Result table and deletes them 
  	@results = Result.all
  	@results.delete_all
  	@ticker = params[:ticker]

  # Encode the given URL to be sent to the AlchemyAPI	

  	encodeUrl = URI.encode("#{params[:ticker]}", /(?!\.)\W/)
					
					puts "Encoded URL: #{encodeUrl}"

 					#Strips off the beginning double quotation marks 
					oldUrl = "#{encodeUrl}".gsub("%5B%22","")
					puts oldUrl


					# Strips of the ending double quotation marks
					myUrl = oldUrl.gsub("%22%5D","")
					puts myUrl
					myTarget = "#{params[:target]}"
					
#  Must use your own API Key
					apikey = "#{ENV['alchemyapi_key']}"


					puts "#{myTarget}"
					puts "#{myUrl}"
					puts myUrl


				 	alcquery = "http://gateway-a.watsonplatform.net/calls/url/URLGetTargetedSentiment?target=#{myTarget}&url=" + "#{myUrl}" + "&apikey=" + apikey + "&outputMode=json&showSourceText=1&sourceText=cleaned"
					
					puts alcquery
					
# Hits the AlchemyAPI
					response = RestClient.get(alcquery)


	# 'response' is parsed in to 'alcresult' and collected into an table called "Result".
					alcresult = JSON.parse(response)
						

					if alcresult["status"] != "ERROR"
						result = Result.new
						result.target = @target
						result.urltext = alcresult["text"]
						result.url = params[:ticker]
						result.senttype = alcresult["docSentiment"]["type"]
						result.score = alcresult["docSentiment"]["score"]
						result.save

#Tests that the appropriate output was  parsed via the terminal						
						puts alcresult["url"], alcresult["docSentiment"]["type"], alcresult["docSentiment"]["score"]

						
					end

					@results = Result.all
				






  end
end
