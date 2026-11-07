import { defineType, defineField } from 'sanity'

export const pickType = defineType({
    name: 'pick',
    title: 'Pick',
    type: 'document',

    fields: [
        defineField({
            name: 'title',
            title: 'Title',
            type: 'string',
        }),
        defineField({
            name: 'kind',
            title: 'Kind',
            type: 'string',
            options: {
                list: [
                    { title: 'Book', value: 'book' },
                    { title: 'Movie', value: 'movie' },
                ],
            },
        }),
        defineField({
            name: 'externalId',
            title: 'External ID',
            type: 'string',
        }),
        defineField({
            name: 'note',
            title: 'Note',
            type: 'text',
        }),
    ],
})