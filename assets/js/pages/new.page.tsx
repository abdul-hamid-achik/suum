import React from 'react'
import {Textarea, Field, Label, Control, Input} from 'bloomer'
const New = () => {
	return <div>
		<Field>
			<Label>Name for the call</Label>
			<Input type="text" placeholder={new Date().toISOString()} />
		</Field>
	</div>
}

export default New