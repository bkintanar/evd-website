{ci_language file="subject"}
{include file='overall_header.tpl'}
{$plus_this}&nbsp;{$tweet_this}
<br />
{$paginateLinks}
<br />
<br />
<table>
<tr><th>Minister's Name</th><th>Login</th><th>Email</th><th>Last Login</th></tr>
{foreach from=$users key=city_id item="user"}
	<tr><td>{$user->getPastorNameWithTitle()|utf}</td><td>{$user->getUserLogin()|utf}</td><td>{$user->getUserEmail()|utf}</td><td>{$user->getUserLastLogin()->format( 'D M jS Y H:i' )}</td></tr>
{/foreach}
</table>
<br />
{$paginateLinks}
{include file='overall_footer.tpl'}