SimpleSchema.messages
  required: '[label] est nécessaire'
  minString: '[label] doit contenir [min] caractères'
  maxString: '[label] ne doit pas excéder [max] caractères'
  minNumber: '[label] doit être supérieur ou égal à [min]'
  maxNumber: '[label] ne peut être supérieur à [max]'
  minDate: '[label] doit être exactement égal ou après [min]'
  maxDate: '[label] doit être avant [max]'
  minCount: 'Vous devez entrer au moins [minCount] valeurs'
  maxCount: 'Vous ne devez pas entrer plus de [maxCount] valeurs'
  noDecimal: '[label] doit être un entier'
  notAllowed: '[value] n\'est pas une valeur autorisée'
  expectedString: '[label] doit être une chaîne de caractères'
  expectedNumber: '[label] doit être un nombre'
  expectedBoolean: '[label] doit être un booléen'
  expectedArray: '[label] doit être un tableau'
  expectedObject: '[label] doit être un objet'
  expectedConstructor: '[label] doit être du [type]'
  regEx: [
    {msg: '[label] ne satisfait pas l\'expression régulière'}
    {
      exp: SimpleSchema.RegEx.Email
      msg: '[label] doit être une adresse e-mail valide'
    }
    {
      exp: SimpleSchema.RegEx.WeakEmail
      msg: '[label] doit être une adresse e-mail valide'
    }
    {
      exp: SimpleSchema.RegEx.Domain
      msg: '[label] doit être un nom de domaine valide'
    }
    {
      exp: SimpleSchema.RegEx.WeakDomain
      msg: '[label] doit être un nom de domaine valide'
    }
    {
      exp: SimpleSchema.RegEx.IP
      msg: '[label] doit être une adresse IPv4 ou IPv6 valide'
    }
    {
      exp: SimpleSchema.RegEx.IPv4
      msg: '[label] doit être une adresse IPv4 valide'
    }
    {
      exp: SimpleSchema.RegEx.IPv6
      msg: '[label] doit être une adresse IPv6 valide'
    }
    {
      exp: SimpleSchema.RegEx.Url
      msg: '[label] doit être une URL valide'
    }
    {
      exp: SimpleSchema.RegEx.Id
      msg: '[label] doit être un ID alphanumérique valide'
    }
  ]
  keyNotInSchema: '[key] non autorisée dans le schéma'
