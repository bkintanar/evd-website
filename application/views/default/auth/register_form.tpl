{include file="overall_header.tpl"}
{ci_form type="open" url="auth/register"}
<table>
	{if $use_username}
	<tr>
		<td>{ci_form type="label" text="Username" id="username"}</td>
		<td>{ci_form type="input" name="username" id="username" value="{ci_form_validation field='username'}" maxlength="80"}</td>
		<td style="color: red;">{ci_form_validation field='username' error='true'}</td>
	</tr>
	{/if}
	<tr>
		<td>{ci_form type="label" text="Email Address" id="email"}</td>
		<td>{ci_form type="input" name="email" id="email" value="{ci_form_validation field='email'}" maxlength="80"}</td>
		<td style="color: red;">{ci_form_validation field='email' error='true'}</td>
	</tr>
	<tr>
		<td>{ci_form type="label" text="Password" id="password"}</td>
		<td>{ci_form type="password" name="password" id="password" maxlength="80" size="30"}</td>
		<td style="color: red;">{ci_form_validation field='password' error='true'}</td>
	</tr>
	<tr>
		<td>{ci_form type="label" text="Confirm Password" id="confirm_password"}</td>
		<td>{ci_form type="password" name="confirm_password" id="confirm_password" maxlength="80" size="30"}</td>
		<td style="color: red;">{ci_form_validation field='confirm_password' error='true'}</td>
	</tr>
    {if $captcha_registration}
		{if $use_recaptcha}
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
		<td style="color: red;">{ci_form_validation field='recaptcha_response_field' error='true'}</td>
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
		<td>{ci_form type="label" text="Confirm Code" id="captcha"}</td>
		<td>{ci_form type="input" name="captcha" id="captcha" maxlength="8"}</td>
		<td style="color: red;">{ci_form_validation field='captcha' error='true'}</td>
	</tr>
	   {/if}
	{/if}
</table>
{ci_form type="submit" name="register" value="Register"}
{ci_form type="close"}
{include file="overall_footer.tpl"}