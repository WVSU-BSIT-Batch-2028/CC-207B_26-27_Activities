
import {defineField, defineType} from 'sanity'

export const fairEvent = defineType({
  name: 'fairEvent',
  title: 'Fair Event',
  type: 'document',

  fields: [
    defineField({
      name: 'title',
      title: 'Event Title',
      type: 'string',
      validation: (Rule) => Rule.required(),
    }),

    defineField({
      name: 'orgId',
      title: 'Organization',
      type: 'string',
      options: {
        list: [
          {title: 'CSC', value: 'csc'},
          {title: 'ITSO', value: 'itso'},
          {title: 'Pixel Arts Guild', value: 'pixel'},
          {title: 'Tunog CICT', value: 'tunog'},
        ],
      },
      validation: (Rule) => Rule.required(),
    }),

    defineField({
      name: 'startsAt',
      title: 'Start Date and Time',
      type: 'datetime',
      validation: (Rule) => Rule.required(),
    }),

    defineField({
      name: 'venue',
      title: 'Venue',
      type: 'string',
      validation: (Rule) => Rule.required(),
    }),

    defineField({
      name: 'description',
      title: 'Description',
      type: 'text',
    }),

    defineField({
      name: 'cancelled',
      title: 'Cancelled',
      type: 'boolean',
      initialValue: false,
    }),
  ],
})
