{include file='overall_header.tpl'}
{$plus_this}&nbsp;{$tweet_this}
{if $article}
<h1>{$article->getArticleTitle()}</h1>
{if $tags}
<h5>Tags: 
{foreach from=$tags key=tag_id item="tag"}
	{$tag->getTagName()}
{/foreach}
</h5>
{/if}
<p><i>by {$article->getArticleAuthor()} on {$article->getArticleDateCreated()->format( 'D M jS Y H:i' )}</i></p>
{$article->getArticleText()|utf}
{/if}
<br />
<br />
{include file='disqus.tpl'}
{include file='overall_footer.tpl'}