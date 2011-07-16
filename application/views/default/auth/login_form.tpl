{include file="overall_header.tpl"}
{if isset($login_by_username) && isset($login_by_email)}
    {assign var="login_label" value="Email or Login"}
{elseif isset($login_by_username)}
    {assign var="login_label" value="Login"}
{else}
    {assign var="login_label" value="Email"}
{/if}
<form id="login_form">
<table>
	<tr>
		<td>{ci_form type="label" text="$login_label" id=""}</td>
		<td>{ci_form type="input" name="login" id="login" size="30" value="{ci_form_validation field='login'}"}</td>
		<td>{ci_form_validation field='login' error='true'}</td>
	</tr>
	<tr>
		<td>{ci_form type="label" text="Password" id="password"}</td>
		<td>{ci_form type="password" name="password" id="password" size="30" value="{ci_form_validation field='password'}"}</td>
		<td>{ci_form_validation field='password' error='true'}</td>
	</tr>

    {if $show_captcha == true}
        {if $use_recaptcha == true}
	<tr>
		<td colspan="2">
			<div id="recaptcha_image"></div>
		</td>
		<td>
			<a href="javascript:Recaptcha.reload()">Get another CAPTCHA</a>
			<div class="recaptcha_only_if_image"><a href="javascript:Recaptcha.switch_type('audio')">Get an audio CAPTCHA</a></div>
			<div class="recaptcha_only_if_audio"><a href="javascript:Recaptcha.switch_type('image')">Get an image CAPTCHA</a></div>
		</td>
	</tr>
	<tr>
		<td>
			<div class="recaptcha_only_if_image">Enter the words above</div>
			<div class="recaptcha_only_if_audio">Enter the numbers you hear</div>
		</td>
		<td><input type="text" id="recaptcha_response_field" name="recaptcha_response_field" /></td>
		<td>{ci_form_validation field='recaptcha_response_field' error='true'}</td>
		{$recaptcha_html}
	</tr>
	   {else}
	<tr>
		<td colspan="3">
			<p>Enter the code exactly as it appears:</p>
			{$captcha_html}
		</td>
	</tr>
	<tr>
		<td>{ci_form type="label" text="Confirmation Code" id="captcha"}</td>
		<td>{ci_form type="input" name="captcha" id="captcha" maxlength="8"}</td>
		<td>{ci_form_validation field='captcha' error='true'}</td>
	</tr>
	   {/if}
	{/if}

	<tr>
		<td colspan="3">
            {ci_form type="checkbox" name="remember" id="remember" value="1" checked="{ci_form_validation field='remember'}" style="margin:0;padding:0"}
			{ci_form type="label" text="Remember me" id="remember"}
			<a href="{ci_config name='base_url'}auth/forgot_password/">Forgot password</a>
			<a href="{ci_config name='base_url'}auth/register/">Register</a>
		</td>
	</tr>
</table>
</form>
{ci_form type="submit" name="submit" value="Let me in"}
{include file="overall_footer.tpl"}