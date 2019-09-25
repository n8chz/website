class PagesController < ApplicationController
  before_action :redirect_if_signed_in!, only: [:index]
  skip_before_action :store_location

  PAGES = {
    #"About Exercism": :about,

    "Terms of Service": :terms_of_service,
    "Privacy Policy": :privacy,
    "Code of Conduct": :code_of_conduct,
    "Frequently Asked Questions": :faqs,
    "Command Line Interface": :cli,
    "Exercism's Values": :values,
    "Getting Started": :getting_started,
    "Become a Maintainer": :become_a_maintainer,
    "Report Abuse": :report_abuse,
    "Contact": :contact,
    "How to Contribute": :contribute,
    "Mentored Mode vs Independent Mode": :mentored_mode_vs_independent_mode,

    "Strategy": :strategy,
    "Roadmap": :roadmap,
    "Changelog": :changelog,

    "Mentoring Guide": :mentoring_guide,
    "Getting started with mentoring": :mentoring_getting_started,
    "Mentoring workflow": :mentoring_workflow,
    "Mentoring FAQs": :mentoring_faqs,

    "About the new site": :about_v1_to_v2,
    "Migrating to the new CLI": :cli_v1_to_v2,
  }

  HELP_PAGES = {
    "Automated solution analysis": :automated_solution_analysis,
    "How do mentor queues work?": :how_do_mentor_queues_work
  }

  LICENCES = {
    "MIT": :mit,
    "CC-BY-SA-4.0": :cc_sa_4
  }

  PAGE_GENERATOR = -> (pages, repo_location) do
    pages.each do |title, page|
      define_method page do
        markdown = Git::WebsiteContent.head.send(repo_location)["#{page}.md"] || ""
        @page = page
        @page_title = title
        @content = ParseMarkdown.(markdown.to_s)
        render action: "generic"
      end
    end
  end

  PAGE_GENERATOR.(PAGES, :pages)
  PAGE_GENERATOR.(LICENCES, :licences)
  PAGE_GENERATOR.(HELP_PAGES, :pages)

  # Landing page
  def index
    @tracks = Track.active.reorder(SQLSnippets.random).to_a
  end

  def cli_walkthrough
    @walkthrough = RenderUserWalkthrough.(
      current_user,
      Git::WebsiteContent.head.walkthrough
    )
  end

  def about
  end

  def supporter_mozilla
    @supporter_name = "Mozilla"
    @supporter_logo = "mozilla-white.png"
    @supporter_website_url = "https://foundation.mozilla.org"

    @supporter_support_details = ParseMarkdown.(%q{
      Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    }.strip)

    @supporter_about = ParseMarkdown.(%q{
      Mozilla is a global non-profit dedicated to putting you in control of your online experience and shaping the future of the web for the public good.
    }.strip)

    render action: 'supporter'
  end

  def supporter_sloan
    @supporter_name = "The Sloan Foundation"
    @supporter_logo = "sloan-white.png"
    render action: 'supporter'
  end

  def supporter_thalamus
    @supporter_name = "Thalamus"
    @supporter_logo = "thalamus-white.png"
    render action: 'supporter'
  end
end
