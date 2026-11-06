
import {defineType, defineField} from 'sanity'

export const pickType = defineType({
  name: 'pick',
  title: 'Pick',
  type: 'document',

  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      validation: (Rule) => Rule.required(),
    }),

    defineField({
      name: 'kind',
      title: 'Kind',
      type: 'string',
      options: {
        list: [
          {title: 'Book', value: 'book'},
          {title: 'Movie', value: 'movie'},
        ],
      },
      validation: (Rule) => Rule.required(),
    }),

    defineField({
      name: 'externalId',
      title: 'External ID',
      type: 'string',
      validation: (Rule) => Rule.required(),
    }),

    defineField({
      name: 'note',
      title: 'Recommendation Note',
      type: 'text',
      rows: 4,
      validation: (Rule) => Rule.required(),
    }),
  ],

  preview: {
    select: {
      title: 'title',
      subtitle: 'kind',
    },
  },
})