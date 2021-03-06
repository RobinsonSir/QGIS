%ModuleHeaderCode
#include <qgsvectorlayerdirector.h>
%End

/**
 * \ingroup analysis
 * \class QgsGraphDirector
 * \brief Determine making the graph. QgsGraphBuilder and QgsGraphDirector
 * are implemented using "builder" design patter.
 */
class QgsGraphDirector : QObject
{
%TypeHeaderCode
#include <qgsgraphbuilder.h>
%End

%ConvertToSubClassCode
  if ( dynamic_cast< QgsVectorLayerDirector* > ( sipCpp ) != NULL )
    sipType = sipType_QgsVectorLayerDirector;
  else
    sipType = NULL;
%End


  signals:
    void buildProgress( int, int ) const;
    void buildMessage( const QString& ) const;

  public:
    //! Destructor
    virtual ~QgsGraphDirector();

    /**
     * Make a graph using QgsGraphBuilder
     *
     * @param builder the graph builder
     * @param additionalPoints list of points that should be snapped to the graph
     * @param snappedPoints list of snapped points
     * @note if snappedPoints[i] == QgsPoint(0.0,0.0) then snapping failed.
     */
    virtual void makeGraph( QgsGraphBuilderInterface *builder,
                            const QVector< QgsPoint > &additionalPoints,
                            QVector< QgsPoint > &snappedPoints /Out/ ) const;

    //! Add optimization strategy
    void addStrategy( QgsNetworkStrategy* prop /Transfer/);

    //! Returns director name
    virtual QString name() const = 0;
};

