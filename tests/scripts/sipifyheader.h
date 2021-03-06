/***************************************************************************
                      sipifyheader.h - Demo for sipify.pl
                     --------------------------------------
Date                 : 28.03.2017
Copyright            : (C) 2017 Denis Rouzaud
email                : denis.rouzaud@gmail.com
 ***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

#ifndef SIPIFYHEADER_H
#define SIPIFYHEADER_H

#include "qgis_core.h"
#include <QtClass>

#include "sipifyheader.h"

// one shall include qgis.h to use SIP annotations
#include "qgis.h"

class QgsForwardDeclaration;


/***************************************************************************
 * This is some random block comment that will not be displayed.
 * Block comments shall will placed upon class, method, enum without
 * any blank lines in between.
 ****************************************************************************/

// typedef have no Docstring, so commenting here will not be used
#ifdef SIP_RUN
typedef qint64 QgsFeatureId;
#else
typedef WhatEver ShouldNotBeDisplayed;
#endif

typedef QSet<QgsFeatureId SIP_PYTYPE( qint64 )> QgsFeatureIds;
typedef QMap<QgsFeatureId SIP_PYTYPE( qint64 ), QgsAttributeMap SIP_PYTYPE( 'QMap<int, QVariant>' )> QgsChangedAttributesMap;
typedef QMap<QgsFeatureId, QgsAttributeMap> SIP_PYTYPE( 'QMap<qint64, QMap<int, QVariant> >' ) QgsChangedAttributesMap;
typedef QMap<QgsFeatureId, QPair<QMap<Something, Complex> >>  SIP_PYTYPE( 'QMap<qint64, QMap<int, QVariant>>' ) QgsChangedAttributesMap;

/** \ingroup core
 * A super QGIS class
 */
#ifndef SIP_RUN // following will be hidden
class CORE_EXPORT QgsSuperClass : public QtClass<QVariant>
{
  public:
    //! A constructor with definition in header
    QgsSuperClass()
      : QtClass<QVariant>()
    {}
};
#else // following will be displayed in generated file
typedef QVector<QVariant> QgsSuperClass;

% MappedType QgsSuperClass
{
  // The annotations are modified by astyle (these will be fixed by sipify.pl)
  % TypeHeaderCode
#include <qgssipifyheader.h>
  % End

  % ConvertFromTypeCode
  // Create the list.
  PyObject *l;
  return l;
  % End
}
#endif

/** \ingroup core
 * Documentation goes here
 *
 * Here's some comment mentioning another class QgsAutoAwesomemater::makeAwesome.
 * \since QGIS 3.0
 * \note some other note
 */
class CORE_EXPORT QgsSipifyHeader : public QtClass<QVariant>, private Ui::QgsBaseClass
{

#ifdef SIP_RUN
    SIP_CONVERT_TO_SUBCLASS_CODE
    if ( sipCpp->headerType() == QgsSipifyHeader::Special )
      sipType = sipType_QgsSpecialSipifyHeader;
    else
      sipType = sipType_QgsStandardSipifyHeader;
    SIP_END
#endif

  public:
    //! This is an enum
    enum MyEnum
    {
      Success = 0, //!< Edit operation was successful
      NoSuccess = 1, //!< Edit operation resulted in an empty geometry
      ImaginarySuccess = 1 << 3, //!< Edit operation resulted in an imaginary geometry
      RecursiveSuccess = 1 << 4, //!< Edit operation resulted in an n-dimensional wormhole
    };
    Q_DECLARE_FLAGS( Flags, MyEnum )

    /**
     * Docstring headers for structs are not supported by sip (as of 4.18) and
     * therefore this docstring must not to be copied to the sipfile.
     */
    struct Data
    {
      QString name;
      int count;
    };

    //! A constructor with definition in header
    explicit QgsSipifyHeader()
      : QtClass<QVariant>()
      , QgsBaseClass()
    {}

    /*
     * A classic constructor with arguments
     */
    QgsSipifyHeader( QWidget *parent SIP_TRANSFERTHIS = nullptr );

    //! A constructor with no empty `()`
    QgsSipifyHeader( bool a = true )
      : mMember( nullptr )
    {}

    //! A constructor with some special character types
    QgsSipifyHeader( QList<Point> a, const Issues &b = Issues::weDontHaveIssues(), QgsClass *b = nullptr )
      : mMember( nullptr )
    {}

    //! Default constructor
    QgsSipifyHeader() = default;

    //! Assignment operator should be removed in sip
    QgsSipifyHeader &operator=( const QgsSipifyHeader other );

    //! Comparison operator should be kept
    bool operator==( const QgsSipifyHeader other );

    //! A multiline method signature
    void multilineMethod( const QgsPoint &startPoint,
                          QgsFeatureId featureId,
                          QgsVectorLayer *vl,
                          QgsSnapper::SnappingType snap_to ) const;

    // Adding SIP_SKIP at the end of a line will discard this MethodCode
    bool thisShouldBeSkipped() const SIP_SKIP;

    //! Factory annotation
    virtual QgsMapLayerRenderer *createMapRenderer( QgsRenderContext &rendererContext ) override SIP_FACTORY;

    SomeObject *createAnother() SIP_FACTORY { return something; }

    /**
     * My long doc string
     * is not very interesting!
     */
    void LongDocStringMethod();

    /**
     * \brief some brief
     * My long doc \a string
     * is not very interesting!
     * Here's some comment mentioning another class QgsAutoAwesomemater::makeLessAwesome.
     */
    void LongDocStringMethodWithBrief();

    /**
     * I return a pointer. If something bad happens, I return nullptr.
    * \returns pointer to something cool
     */
    MyPointer *pointerReturnValue();

    bool isOKwithErrMesg( QString &ErrMsg SIP_OUT );

    void InOutParam( bool &ok = true SIP_INOUT );

    void setDiagramRenderer( QgsDiagramRenderer *r SIP_TRANSFER );

    void differentDefaultValue( bool defaultValue = true SIP_PYDEFAULTVALUE( false ), QWidget *parent = nullptr, QString msg = QString() SIP_PYDEFAULTVALUE( "hello" ) );

    void differentType( QList<QgsFeatureId> SIP_PYTYPE( QList<qint64> ) & list );

    //! complex default value and type (i.e. containing commas) should be given as a string with single quotes
    void complexDefaultValueAndType( QList<QPair<QgsFeatureId SIP_PYTYPE( qint64 ), QMap<int, QString>>> list = QList<QPair<QgsFeatureId, QMap<int, QString>>>() SIP_PYDEFAULTVALUE( 'QList<QPair<qint64, QMap<int, QString>>>()' ) );

    inline int inlineKeyWordShouldNotAppear();

    QString labelForRange( double lower, double upper ) const SIP_PYNAME( labelForLowerUpper );

    void setComposition( QgsComposition *c SIP_KEEPREFERENCE );

    void removeProxyFactory( QNetworkProxyFactory *factory SIP_TRANSFERBACK );

    bool removeFunctionBody( const QList<int, QString> &list, QgsVectorLayer *vl ) { doSomething; return true; }   // some comments

    //! Removing function body with namespaced return value
    QgsRaster::RasterBuildPyramids buildPyramidsFlag() const { return mBuildPyramidsFlag; }

    bool deletedFunction() = delete; // some comments

    virtual int overriddenProperty() override { return 42; } // if in doubt, comment it out

    QString returnTypeString() const;

    double returnTypeDouble() const;

    QList< QgsAnnotation * > returnTypeList();

    QVector< QgsAnnotation > returnTypeVector();

    QStringList returnTypeStringList();

    QSet<QgsActionScope> returnTypeSet();

  protected:
    bool thisShouldBeListed();

    Whatever skipMember;
    Whatever::Something *alsoSkipMember = nullptr;

  private:
    void privateMethodAreNotShown();
#ifdef SIP_RUN
    void privateMethodSIPRUNareShown();
#endif
  public:
    void FallBackToPublic();

  private:
    void PrivateAgain();

    struct ProcessFeatureWrapper
    {
      QgsGeometrySnapper *instance = nullptr;
      double snapTolerance;
      SnapMode mode;
      explicit ProcessFeatureWrapper( QgsGeometrySnapper *_instance, double snapTolerance, SnapMode mode )
        : instance( _instance )
        , snapTolerance( snapTolerance )
        , mode( mode )
      {}
      void operator()( QgsFeature &feature ) { return instance->processFeature( feature, snapTolerance, mode ); }
    };

    enum PointFlag { SnappedToRefNode, SnappedToRefSegment, Unsnapped };
};

/**
 * \class ClassWithPrivateInheritanceOnly
 * \ingroup core
 * Documentation goes here
 */
class CORE_EXPORT ClassWithPrivateInheritanceOnly : private QgsBaseClass
{
  public:
    //! A constructor with definition in header on several lines
    explicit ClassWithPrivateInheritanceOnly()
      : QtClass<QVariant>()
      , QgsBaseClass()
    {
      doWhatYouLike();
      haveFun();
    }

};

/**
 * \class AbstractClass
 * \ingroup core
 * Documentation goes here
 */
class CORE_EXPORT AbstractClass SIP_ABSTRACT
{
  public:
    //! A constructor
    explicit AbstractClass()
    {
    }

  private:

    /**
     * This method should be overridden by subclasses but not exposed to the public
     * or protected API.
     */
    virtual QString reason() = 0;
}

Q_DECLARE_OPERATORS_FOR_FLAGS( QgsSipifyHeader::Flags )


#endif
