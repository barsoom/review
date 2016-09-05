defmodule Exremit.CommitSerializer do
  # Some argue 50 chars is a good length for the summary part of a commit message.
  # http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
  @message_summary_length 50

  def serialize(commits) when is_list(commits) do
    commits |> Parallel.pmap(&serialize/1)
  end

  def serialize(commit) do
    payload = parse_payload(commit)

    %{
      id: commit.id,
      summary: summary(payload),
      authorGravatarHash: gravatar_hash(commit.author),
      pendingReviewerGravatarHash: gravatar_hash(commit.review_started_by_author),
      pendingReviewerEmail: email(commit.review_started_by_author),
      reviewerEmail: email(commit.reviewed_by_author),
      reviewerGravatarHash: gravatar_hash(commit.reviewed_by_author),
      repository: repository(payload),
      authorName: author_name(commit),
      timestamp: timestamp(payload),
      isNew: !commit.review_started_at,
      isBeingReviewed: !!commit.review_started_at && !commit.reviewed_at,
      isReviewed: !!commit.reviewed_at,
      url: url(payload),
    }
  end

  defp summary(payload) do
    payload.message
    |> String.split("\n")
    |> List.first
    |> String.slice(0, @message_summary_length)
  end

  defp email(nil), do: nil
  defp email(author), do: author.email

  defp gravatar_hash(nil), do: gravatar_hash(%{ email: "show-a-placeholder" })
  defp gravatar_hash(author) do
    :crypto.hash(:md5, author.email)
    |> Base.encode16(case: :lower)
  end

  defp repository(payload), do: payload.repository.name
  defp author_name(commit), do: commit.author.name
  defp timestamp(payload), do: payload.timestamp
  defp url(payload), do: payload.url

  defp parse_payload(commit) do
    Poison.decode!(commit.json_payload, keys: :atoms)
  end
end
