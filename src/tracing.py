from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from dotenv import load_dotenv 
import os

def setup_opentelemetry(app):
    honeycomb_api_key = os.getenv('HONEYCOMB_API_KEY')
    honeycomb_dataset = os.getenv('HONEYCOMB_METRICS_DATASET')
    honeycomb_service_name = os.getenv('OTEL_SERVICE_NAME')
    endpoint = os.getenv('OTEL_EXPORTER_OTLP_ENDPOINT')

    exporter = OTLPSpanExporter(
        endpoint=endpoint,
        headers={"x-honeycomb-team": honeycomb_api_key, "x-honeycomb-dataset": honeycomb_dataset},
    )

# Set up the tracer provider and attach the exporter
    tracer_provider = TracerProvider()
    span_processor = BatchSpanProcessor(exporter)
    tracer_provider.add_span_processor(span_processor)
    trace.set_tracer_provider(tracer_provider)

    # Instrument the Flask application
    FlaskInstrumentor().instrument_app(app)